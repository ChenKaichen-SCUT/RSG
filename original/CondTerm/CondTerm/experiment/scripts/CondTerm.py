import argparse
import copy
import sys
import os
import random
sys.path.append(os.path.abspath('src'))
from IceTerm import IceTerm #pylint: disable=import-error
from Logger import Logger #pylint: disable=import-error
import xml.etree.ElementTree as ET
import pickle
import datetime
import shutil
import subprocess, signal
from functools import reduce
import time
from sympy import *
import csv


parser = argparse.ArgumentParser(description='ddlTerm')

parser.add_argument("--name")
parser.add_argument("--ledir")
parser.add_argument("--nledir")
parser.add_argument("--seed", default=888)
parser.add_argument("--tmp", default="tmp")
parser.add_argument("--test", default="test")
parser.add_argument("--vars")
parser.add_argument("--conf")
# parser.add_argument("--log", default=None)
parser.add_argument("--excel", default=None)

args = parser.parse_args()
task_name = args.name
task_ledir = args.ledir
task_nledir = args.nledir
task_seed = int(args.seed)
task_tmp = args.tmp
task_vars = args.vars
task_test = args.test
task_conf = args.conf
# task_log = args.log
task_excel = args.excel


def kill_by_name(name):
    p = subprocess.Popen(['ps', '-A'], stdout=subprocess.PIPE)
    out, err = p.communicate()
    for line in out.decode().splitlines():
        if name in line:
            try:
                pid = int(line.split(None, 1)[0])
                os.kill(pid, signal.SIGKILL)
                print(f'[Warning] Process {name}@{pid} found. Automatically killed.')
            except ProcessLookupError:
                ...
    # import pdb;pdb.set_trace()


def kill_related_process():
    for name in ['z3', 'mono', 'c5.0']:
        kill_by_name(name)


# for data saving
dataSavingPara = {
    'base_fields': [],
    'existing_samples': {},
    'imp_info': {},
    'start_testDataInfo': [],  # for nle
    'MData': [],  # for nle
    'BoundLearningTraces': [],  # for le
}
sample2index = {}
updated_csv = False
updated_imp = False
reuse_maxAbs = 500
# start_testDataInfo_le = []
# start_testDataInfo_nle = []
# for debug
# base_fields = ['x', 'y']
# existing_samples = {(1,2): [1,2,3,'term'], (2,2): [2,2,'','?'], (9, 4): {'x': 9, 'y': 4, 'r': 1, 'attr': 'term'}, (127, 3): {'x': 127, 'y': 3, 'attr': 'term'}}  # for debug


def checkReuse(tuple):
    for num in tuple:
        if abs(num) >= reuse_maxAbs:
            return False
    return True


# update data to storage file
def updateStorageData():
    print('[DataSaving] write data into storage files.')
    # rewrite storage file
    if updated_csv:
        # storageFile = os.path.join(storageDir, 'storage.csv')
        # file_is_empty = not os.path.exists(storageFile) or os.stat(storageFile).st_size == 0
        with open(storageFile, mode='w', newline='') as csv_file:
            writer = csv.writer(csv_file)
            if dataSavingPara['base_fields'] != []:
                fields = dataSavingPara['base_fields'] + ['r', 'attr']
                writer.writerow(fields)
            index = 0
            for key, value in dataSavingPara['existing_samples'].items():
                if isinstance(value, dict):
                    row = []
                    for header in fields:
                        row.append(value.get(header, ''))
                    writer.writerow(row)
                else:  # list
                    writer.writerow(value)
                sample2index[key] = index
                index += 1
    if updated_imp:
        with open(impFile, mode='w', newline='') as file:
            for left, right in dataSavingPara['imp_info'].items():
                index_l = sample2index[left]
                index_r = sample2index[right]
                line = '{} {}\n'.format(index_l, index_r)
                file.write(line)


# record data from ddlterm & ice
def recordTermData(testDataInfo, ICEData):
    recordTestDataInfo(testDataInfo)
    recordICEData(ICEData)


def recordICEData(ICEData):
    if len(dataSavingPara['existing_samples']) == 0:
        return
    global updated_csv, updated_imp
    datalist, implist = ICEData
    # update imp_info
    # updated_imp = false
    update_num = 0
    for imp_data in implist[:-1]:
        left, right = imp_data.split(' ')
        l_index = int(left.strip())
        r_index = int(right.strip())
        l_rawdata = datalist[l_index].strip()
        r_rawdata = datalist[r_index].strip()
        l_values = l_rawdata.split(',')
        r_values = r_rawdata.split(',')
        for base in dataSavingPara['existing_samples'].keys():
            base_field_num = len(base)
            break
        l_base = tuple([int(x) for x in l_values[1:base_field_num+1]])
        if not checkReuse(l_base):
            continue
        r_base = tuple([int(x) for x in r_values[1:base_field_num+1]])
        if not checkReuse(r_base):
            continue
        l_row = list(l_base) + ['', '?']
        r_row = list(r_base) + ['', '?']
        # add sample and imp info
        if not l_base in dataSavingPara['existing_samples']:
            dataSavingPara['existing_samples'][l_base] = l_row
            updated_csv = true
        if not r_base in dataSavingPara['existing_samples']:
            dataSavingPara['existing_samples'][r_base] = r_row
            updated_csv = true
        if not l_base in dataSavingPara['imp_info']:
            dataSavingPara['imp_info'][l_base] = r_base
            updated_imp = true
            update_num += 1
    print('[DataSaving] record {} ICE imp data.'.format(update_num))
    # print('update imp data: {}'.format(dataSavingPara['imp_info']))
    return


# storage loop bound samples
def recordTestDataInfo(testDataInfo):
    global updated_csv, updated_imp
    # process new samples
    if testDataInfo == []:
        return
    # store 500 samples at most
    if len(dataSavingPara['existing_samples']) >= 500:
        print('[DataSharing] Already store 500 samples, ignored testDataInfo.')
        return
    update_num = 0
    testDataOriginList = []
    # print("testDataInfo:", testDataInfo)
    for testTrace in testDataInfo:
        for stateInfo in testTrace:
            testDataOriginList.append(stateInfo)
    # decuplication
    # testDataList = list(map(dict, {tuple(d.items()) for d in testDataOriginList}))
    seen = set()
    testDataList = []
    for raw in testDataOriginList:
        if len(testDataList) >= 500:
            print('[DataSharing] Already store 500 samples, ignored the rest testDataInfo.')
            break
        key = tuple(raw.items())
        if key not in seen:
            seen.add(key)
            # testDataList.append(raw)
            testDataList.append(copy.deepcopy(raw))
    # global base_fields
    dataSavingPara['base_fields'] = [key for key in testDataList[0].keys() if key != 'r']
    fields = dataSavingPara['base_fields'] + ['r', 'attr']

    # update dataSavingPara['existing_samples']
    for row in testDataList:
        row['attr'] = 'term'
        key = tuple(row[field] for field in dataSavingPara['base_fields'])  # 生成唯一key
        if key in dataSavingPara['existing_samples']:
            # update existing sample
            if not dataSavingPara['existing_samples'][key] == row:
                dataSavingPara['existing_samples'][key] = row
                updated_csv = true
                update_num += 1
        else:
            if not checkReuse(key):
                continue
            # add new sample
            dataSavingPara['existing_samples'][key] = row
            updated_csv = true
            update_num += 1
    # print('update existing samples:{}'.format(dataSavingPara['existing_samples']))
    print('[DataSaving] record {} test data.'.format(update_num))


# record terminating(false) & implicative samples from RSLearn
def recordRSLData(rslFileName):
    global updated_csv, updated_imp
    update_num = 0
    update_num_imp = 0
    # read rsl data
    rsl_data_file = os.path.join(task_tmp, rslFileName+'.data')
    rsl_imp_file = os.path.join(task_tmp, rslFileName + '.implications')
    imp_list = []
    if os.path.exists(rsl_data_file) and os.access(rsl_data_file, os.R_OK) and os.path.getsize(rsl_data_file) > 0:
        with open(rsl_data_file, 'r') as f:
            data_list = f.readlines()
    else:  # no data
        return
    if os.path.exists(rsl_imp_file) and os.access(rsl_imp_file, os.R_OK) and os.path.getsize(rsl_imp_file) > 0:
        with open(rsl_imp_file, 'r') as f:
            imp_list = f.readlines()

    basedata_list = []
    # update existing_samples
    # updated_csv = false
    for rsl_data in data_list:
        values = rsl_data.split(',')
        if len(values) == 1:
            continue
        base_value = tuple([int(x) for x in values[1:-1]])
        if 'false' in values[-1]:
            # add terminating sample
            basedata_list.append([base_value,])
            if base_value in dataSavingPara['existing_samples']:
                row = dataSavingPara['existing_samples'][base_value]
                if isinstance(row, dict):
                    if row['attr'] != 'term':
                        row['attr'] = 'term'
                        updated_csv = true
                        update_num += 1
                else:  # list
                    if not 'term' in row:
                        row[-1] = 'term'
                        updated_csv = true
                        update_num += 1
            else:
                if not checkReuse(base_value):
                    continue
                updated_csv = true
                update_num += 1
                row = [int(x) for x in values[1:-1]] + ['','term']
                dataSavingPara['existing_samples'][base_value] = row
        else:
            attr = values[-1].strip()
            row = [int(x) for x in values[1:-1]] + ['', attr]
            basedata_list.append([base_value, row])
    # print('updated={}, update existing samples:{}'.format(updated_csv, existing_samples))

    # update imp_info
    # updated_imp = false
    for imp_data in imp_list[:-1]:
        left, right = imp_data.split(' ')
        left = left.strip()
        right = right.strip()
        l_base = basedata_list[int(left)][0]
        if not checkReuse(l_base):
            continue
        r_base = basedata_list[int(right)][0]
        if not checkReuse(r_base):
            continue
        # if 'true' in l_row or 'true' in r_row:  # ignore non-terminating samples
        #     continue
        # add sample and imp info
        if not l_base in dataSavingPara['existing_samples']:
            l_row = basedata_list[int(left)][1]
            if 'true' in l_row:
                continue
            dataSavingPara['existing_samples'][l_base] = l_row
            updated_csv = true
        if not r_base in dataSavingPara['existing_samples']:
            r_row = basedata_list[int(right)][1]
            if 'true' in r_row:
                continue
            dataSavingPara['existing_samples'][r_base] = r_row
            updated_csv = true
        if not l_base in dataSavingPara['imp_info']:
            dataSavingPara['imp_info'][l_base] = r_base
            updated_imp = true
            update_num_imp += 1
    print('[DataSaving] record RSL data: {} term and {} imp.'.format(update_num, update_num_imp))


def runInitialTest(variableInfo, taskOPath, iteration):
    random.seed(task_seed+iteration)  # use tsak_seed directly? store the samples?
    allSamples = 100
    curSamples = 0
    termSamples = 0
    toSamples = 0
    Timer = ['/usr/bin/timeout', '--foreground', '--kill-after', '1', '0.01']
    testTime = time.time()
    while curSamples < allSamples:
        if curSamples % 5 == 0 and time.time() - testTime > 1:
            break
        process = subprocess.Popen(Timer + [taskOPath], stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        if len(variableInfo) > 0:
            random_numbers = [random.randint(-100, 100) for _ in variableInfo]  # the best para?
            inputStr = str(reduce(lambda x, y: '{} {}'.format(x, y), random_numbers))
            stdout, stderr = process.communicate(input=inputStr.encode())
        else:
            stdout, stderr = process.communicate()
        stdout = stdout.decode()
        stderr = stderr.decode()
        returncode = process.returncode
        if "Assertion" not in stderr:
            curSamples += 1
            if returncode != 0:
                toSamples += 1
                # if toSamples >= 15:
                #     return false, i, toSamples
            else:
                termSamples += 1
    print('[TEST] test {} samples, find {} terminating and {} timeout.'.format(curSamples, termSamples, toSamples))
    if toSamples > termSamples:  # TODO: the best para?
        return false
    return true
    # return true, i, toSamples


def runInitialTestandRecord():
    random.seed(task_seed)
    # compile
    if os.path.exists(taskCPath):
        ret = os.popen('g++ -ftrapv {} -o {}'.format(taskCPath, taskOPath))  # add -ftrapv to handle overflow
        retvalue = ret.read()
        if not retvalue.strip() == '':
            print(retvalue)
    else:
        raise RuntimeError('Compile failed in {}'.format(taskName))
    # initialize iceterm
    logger = Logger(printLevel=logLevel)
    logger.LogStatistic()
    it = IceTerm(taskName, task_tmp, taskBplPath, taskOPath, variableInfo, testRoundDir=task_test, logger=logger)
    it.runRandTestInitial()
    print('[TEST] get {} terminating executions and {} timeout executions'.format(logger.TestTermNum, logger.TestTONum))
    if logger.TestTONum > logger.TestTermNum:
        return false, logger.TestDataInfo
    return true, logger.TestDataInfo


def overallTerminationVerification():
    # check current termination
    # logger.StartTimer('Term_curIteration')
    curTerm_startTime = time.time()
    curTermTime = 0
    testDataInfo = []
    ICEData = [[],[]]
    for strategy in strategyList:
        random.seed(task_seed)
        if strategy['UseLexical']:
            benchDir = task_ledir
        else:
            benchDir = task_nledir

        taskBplPath = os.path.join(benchDir, taskName, '{}.bpl'.format(taskName))
        taskCPath = os.path.join(benchDir, taskName, '{}.c'.format(taskName))
        taskOPath = os.path.join(benchDir, taskName, '{}.o'.format(taskName))
        if iteration > 1:
            taskBplPath = taskBplPath[:-4] + "_assume.bpl"
            taskCPath = taskCPath[:-2] + "_assume.c"
            taskOPath = taskOPath[:-2] + "_assume.o"

        if not os.path.exists(taskOPath) or alwaysCompile:
            if os.path.exists(taskCPath):
                print('[Info] C File find! Trying make compilation...')
                # print('[Info] => Run cmd: {}'.format('g++ {} -o {}'.format(taskCPath, taskOPath)))
                ret = os.popen(
                    'g++ -ftrapv {} -o {}'.format(taskCPath, taskOPath))  # add -ftrapv to handle overflow
                retvalue = ret.read()
                if not retvalue.strip() == '':
                    print(retvalue)
                print('[Info] => Compile success!')
            else:
                raise RuntimeError('Compile failed in {}'.format(taskName))

        logger = Logger(printLevel=logLevel)
        logger.LogStatistic()
        if dataSharePara['DataSaving'] and not strategy['UseLexical']:
            logger.TestDataInfo = initialTestInfo
        it = IceTerm(taskName, task_tmp, taskBplPath, taskOPath, variableInfo, testRoundDir=task_test, logger=logger,
                     timeout=strategy['Timeout'], dataSharePara=dataSharePara, dataSavingPara=dataSavingPara)

        for k in strategy.keys():
            if k == 'Timeout':
                continue
            setattr(it, k, strategy[k])

        try:
            # logger.StartTimer('Term_current')
            it.checkTermination()
            testDataInfo.extend(logger.TestDataInfo)
            ICEData[0].extend(logger.ICEData[0])
            ICEData[1].extend(logger.ICEData[1])
            # TermTimeList.append(logger.Stat_TermTotalTime)
            # it.doVerification()
            logger.FormatBound()
        except RuntimeError as e:
            logger.Stat_Result = "Runtime Error"
            print(e)

        benchLogList.append(logger)
        print('[Info] => Sub-Result: {}'.format(logger.Stat_Result))

        # curTermTime = logger.CalcTimePass('Term_curIteration')
        curTermTime = time.time() - curTerm_startTime
        if logger.Stat_Result == 'Termination':
            TermResult = True
            print('[Info] Bound is:', logger.Stat_FinalBound)
            print('[Info] Inv is:', logger.Stat_FinalInv)
            return "Termination", curTermTime, testDataInfo, ICEData

        # timeout
        if curTermTime >= 40:  # set timeout to be 40
            return "Timeout", curTermTime, testDataInfo, ICEData
        # elif logger.Stat_Result == 'Cond-Termination':
        #     Result = 'Cond-Termination'
        #     print('[Info] Condition is:', logger.Stat_FinalCondition)
        #     # break
        else:
            ...
        # Kill unstopped process
        kill_related_process()
        # Trying next strategy
    curTermTime = time.time() - curTerm_startTime
    return "Unknown", curTermTime, testDataInfo, ICEData


# conduct termination verification using the first strategy only
def firstTerminationVerification():
    curTerm_startTime = time.time()
    curTermTime = 0
    testDataInfo = []
    ICEData = [[], []]
    # for strategy in strategyList:
    strategy = strategyList[0]
    random.seed(task_seed)
    # if strategy['UseLexical']:
    #     benchDir = task_ledir
    # else:
    #     benchDir = task_nledir
    #
    # taskBplPath = os.path.join(benchDir, taskName, '{}.bpl'.format(taskName))
    # taskCPath = os.path.join(benchDir, taskName, '{}.c'.format(taskName))
    # taskOPath = os.path.join(benchDir, taskName, '{}.o'.format(taskName))
    # if iteration > 1:
    #     taskBplPath = taskBplPath[:-4] + "_assume.bpl"
    #     taskCPath = taskCPath[:-2] + "_assume.c"
    #     taskOPath = taskOPath[:-2] + "_assume.o"

    if not os.path.exists(taskOPath) or alwaysCompile:
        if os.path.exists(taskCPath):
            print('[Info] C File find! Trying make compilation...')
            # print('[Info] => Run cmd: {}'.format('g++ {} -o {}'.format(taskCPath, taskOPath)))
            ret = os.popen(
                'g++ -ftrapv {} -o {}'.format(taskCPath, taskOPath))  # add -ftrapv to handle overflow
            retvalue = ret.read()
            if not retvalue.strip() == '':
                print(retvalue)
            print('[Info] => Compile success!')
        else:
            raise RuntimeError('Compile failed in {}'.format(taskName))

    logger = Logger(printLevel=logLevel)
    logger.LogStatistic()
    if dataSharePara['DataSaving']:
        logger.TestDataInfo = initialTestInfo
    it = IceTerm(taskName, task_tmp, taskBplPath, taskOPath, variableInfo, testRoundDir=task_test, logger=logger,
                 timeout=strategy['Timeout'], dataSharePara=dataSharePara, dataSavingPara=dataSavingPara)

    for k in strategy.keys():
        if k == 'Timeout':
            continue
        setattr(it, k, strategy[k])

    try:
        it.checkTermination()
        testDataInfo.extend(logger.TestDataInfo)
        ICEData[0].extend(logger.ICEData[0])
        ICEData[1].extend(logger.ICEData[1])
        logger.FormatBound()
    except RuntimeError as e:
        logger.Stat_Result = "Runtime Error"
        print(e)

    benchLogList.append(logger)
    print('[Info] => Sub-Result: {}'.format(logger.Stat_Result))

    curTermTime = time.time() - curTerm_startTime
    if logger.Stat_Result == 'Termination':
        print('[Info] Bound is:', logger.Stat_FinalBound)
        print('[Info] Inv is:', logger.Stat_FinalInv)
        return "Termination", curTermTime, testDataInfo, ICEData

    kill_related_process()
    # Trying next strategy
    curTermTime = time.time() - curTerm_startTime
    return "Unknown", curTermTime, testDataInfo, ICEData


def remainingTerminationVerification():
    # check current termination
    # logger.StartTimer('Term_curIteration')
    curTerm_startTime = time.time()
    curTermTime = 0
    testDataInfo = []
    ICEData = [[], []]
    for strategy in strategyList[1:]:
        random.seed(task_seed)
        # must be le
        # if strategy['UseLexical']:
        #     benchDir = task_ledir
        # else:
        #     benchDir = task_nledir
        taskBplPath = os.path.join(task_ledir, taskName, '{}.bpl'.format(taskName))
        taskCPath = os.path.join(task_ledir, taskName, '{}.c'.format(taskName))
        taskOPath = os.path.join(task_ledir, taskName, '{}.o'.format(taskName))
        if iteration > 1:
            taskBplPath = taskBplPath[:-4] + "_assume.bpl"
            taskCPath = taskCPath[:-2] + "_assume.c"
            taskOPath = taskOPath[:-2] + "_assume.o"

        if not os.path.exists(taskOPath) or alwaysCompile:
            if os.path.exists(taskCPath):
                print('[Info] C File find! Trying make compilation...')
                # print('[Info] => Run cmd: {}'.format('g++ {} -o {}'.format(taskCPath, taskOPath)))
                ret = os.popen(
                    'g++ -ftrapv {} -o {}'.format(taskCPath, taskOPath))  # add -ftrapv to handle overflow
                retvalue = ret.read()
                if not retvalue.strip() == '':
                    print(retvalue)
                print('[Info] => Compile success!')
            else:
                raise RuntimeError('Compile failed in {}'.format(taskName))

        logger = Logger(printLevel=logLevel)
        logger.LogStatistic()
        it = IceTerm(taskName, task_tmp, taskBplPath, taskOPath, variableInfo, testRoundDir=task_test, logger=logger,
                     timeout=strategy['Timeout'], dataSharePara=dataSharePara, dataSavingPara=dataSavingPara)

        for k in strategy.keys():
            if k == 'Timeout':
                continue
            setattr(it, k, strategy[k])

        try:
            # logger.StartTimer('Term_current')
            it.checkTermination()
            testDataInfo.extend(logger.TestDataInfo)
            ICEData[0].extend(logger.ICEData[0])
            ICEData[1].extend(logger.ICEData[1])
            # TermTimeList.append(logger.Stat_TermTotalTime)
            # it.doVerification()
            logger.FormatBound()
        except RuntimeError as e:
            logger.Stat_Result = "Runtime Error"
            print(e)

        benchLogList.append(logger)
        print('[Info] => Sub-Result: {}'.format(logger.Stat_Result))

        # curTermTime = logger.CalcTimePass('Term_curIteration')
        curTermTime = time.time() - curTerm_startTime
        if logger.Stat_Result == 'Termination':
            TermResult = True
            print('[Info] Bound is:', logger.Stat_FinalBound)
            print('[Info] Inv is:', logger.Stat_FinalInv)
            return "Termination", curTermTime, testDataInfo, ICEData

        # timeout
        if curTermTime >= 40:  # set timeout to be 40
            return "Timeout", curTermTime, testDataInfo, ICEData
        # elif logger.Stat_Result == 'Cond-Termination':
        #     Result = 'Cond-Termination'
        #     print('[Info] Condition is:', logger.Stat_FinalCondition)
        #     # break
        else:
            ...
        # Kill unstopped process
        kill_related_process()
        # Trying next strategy
    curTermTime = time.time() - curTerm_startTime
    return "Unknown", curTermTime, testDataInfo, ICEData


rootET = ET.parse(task_conf).getroot()
logLevel = 0
alwaysCompile = True
# import pdb; pdb.set_trace()
strategyList = []
dataSharePara = {}
fixed_seed = None

print('[Info] Setting the strategy...')
for elem in rootET:
    if elem.tag == 'Name':
        print('[Info] Using strategy {}'.format(elem.text))
        continue
    elif elem.tag == 'Log':
        logLevel = int(elem.text)
    elif elem.tag == 'Tmp':
        # Use explicit tmp directory (Support fast tmpfs feature)
        tmpPath = elem.text
        if not os.path.isdir(tmpPath):
            raise RuntimeError(f'Cannot find the tmp directory {tmpPath}')
        task_tmp = os.path.join(tmpPath, task_tmp)
        task_test = os.path.join(tmpPath, task_test)
    elif elem.tag == 'Complie':
        if elem.text in ['Always', 'always', 'ALWAYS']:
            alwaysCompile = True
        else:
            alwaysCompile = False
    # elif elem.tag == 'FixedSeed':
    #     print('[Info] FixedSeed={}'.format(elem.text))
    #     if elem.text == 'None':
    #         continue
    #     try:
    #         fixed_seed = int(elem.text)
    #     except ValueError:
    #         raise RuntimeError('Unexpected noneable int setting for {}'.format(elem.tag))
    elif elem.tag == 'RSGeneralize':
        print('[Info] RSGeneralize={}'.format(elem.text))
        if elem.text in ['True', 'true', 'TRUE']:
            rsGeneralize = True
        elif elem.text in ['False', 'false', 'FALSE']:
            rsGeneralize = False
        else:
            raise RuntimeError('Unexpected bool setting for {}'.format(elem.tag))
    elif elem.tag == 'DataSaving':
        print('[Info] DataSaving={}'.format(elem.text))
        if elem.text in ['True', 'true', 'TRUE']:
            dataSharePara['DataSaving'] = True
        elif elem.text in ['False', 'false', 'FALSE']:
            dataSharePara['DataSaving'] = False
        else:
            raise RuntimeError('Unexpected bool setting for {}'.format(elem.tag))

    elif elem.tag == 'NLe' or elem.tag == 'Le':
        strategy = {}
        strategy['UseLexical'] = elem.tag == 'Le'
        # Default setting begin.
        strategy['Timeout'] = None
        strategy['TestRound'] = 100
        strategy['UseAdvancedCBC'] = True
        strategy['CBC_Limit'] = 30
        strategy['MLearnTarget'] = 'LSM_L2'
        # Default setting end.

        for setting in elem:
            if setting.tag in ['TestRound','CBC_Limit','TestLB','TestUB','TestNBLB',
                    'TestNBUB','TestNBRound','CBC_Advance','CBC_Advance_Limit',
                    'LexicalRankMin','LexicalRankMax','MLearnClusterNum', 'BMC_Limit']: # int
                try:
                    strategy[setting.tag] = int(setting.text)
                except ValueError:
                    raise RuntimeError('Unexpected int setting for {}'.format(setting.tag))
            
            elif setting.tag in ['MLearnTarget','LexicalStrategy','MLearnStrategy']: # str
                strategy[setting.tag] = setting.text
            
            elif setting.tag in ['UseAdvancedCBC','ErrorNearByTest']: # bool
                if setting.text in ['True', 'true', 'TRUE']:
                    strategy[setting.tag] = True
                elif setting.text in ['False', 'false', 'FALSE']:
                    strategy[setting.tag] = False
                else:
                    raise RuntimeError('Unexpected bool setting for {}'.format(setting.tag))
            elif setting.tag in ['Timeout']: # Noneable int
                if setting.text == 'None':
                    strategy[setting.tag] = None
                else:
                    try:
                        strategy[setting.tag] = int(setting.text)
                    except ValueError:
                        raise RuntimeError('Unexpected noneable int setting for {}'.format(setting.tag))
            else:
                raise RuntimeError('Unknown Tag: {}'.format(setting.tag))
        strategyList.append(strategy)

storageDir = task_tmp[:-3]
storageFile = os.path.join(storageDir, 'storage.csv')
impFile = os.path.join(storageDir, 'storage.imp')

if os.path.exists(task_tmp):
    shutil.rmtree(task_tmp)
    os.mkdir(task_tmp)

if os.path.exists(task_test):
    shutil.rmtree(task_test)
    os.mkdir(task_test)

if os.path.exists(storageFile):
    os.remove(storageFile)
if os.path.exists(impFile):
    os.remove(impFile)

# solvedNum = 0
# runNum = 1
LogList = []

taskName = task_name
print('[Info] Running the task {}...'.format(taskName))
if task_vars == '|':
    variableInfo = []
else:
    variableInfo = list(task_vars.split('|'))

benchLogList = []
TermTimeList = []
NonTermTimeList = []

# logger = Logger(printLevel=logLevel)
# logger.LogStatistic()
# logger.StartTimer('CondTerm_total')
total_start_time = time.time()

Result = 'Failed'
TermResult = False
iteration = 0
cur_condition = parse_expr("0==0")
final_condition = None
while True:
    iteration += 1
    # timeout:
    if iteration > 15:
        iteration -= 1
        Result = 'Timeout'
        break
    print('---Begin Iteration: {} ---'.format(iteration))

    # nle-path
    taskBplPath = os.path.join(task_nledir, taskName, '{}.bpl'.format(taskName))
    taskCPath = os.path.join(task_nledir, taskName, '{}.c'.format(taskName))
    taskOPath = os.path.join(task_nledir, taskName, '{}.o'.format(taskName))
    if iteration > 1:
        taskBplPath = taskBplPath[:-4] + "_assume.bpl"
        taskCPath = taskCPath[:-2] + "_assume.c"
        taskOPath = taskOPath[:-2] + "_assume.o"

    # initial run and test
    print('[Info] Initial run and test...')
    # taskCPath = os.path.join(task_nledir, taskName, '{}.c'.format(taskName))
    # taskOPath = os.path.join(task_nledir, taskName, '{}.o'.format(taskName))
    # if iteration > 1:
    #     taskCPath = taskCPath[:-2] + "_assume.c"
    #     taskOPath = taskOPath[:-2] + "_assume.o"
    # if os.path.exists(taskCPath):
    #     ret = os.popen('g++ -ftrapv {} -o {}'.format(taskCPath, taskOPath))  # add -ftrapv to handle overflow
    #     retvalue = ret.read()
    #     if not retvalue.strip() == '':
    #         print(retvalue)
    # else:
    #     raise RuntimeError('Compile failed in {}'.format(taskName))

    # res = runInitialTest(variableInfo, taskOPath, iteration)
    res, initialTestInfo = runInitialTestandRecord()
    print("initial test result: ", res)
    if dataSharePara['DataSaving']:
        recordTestDataInfo(initialTestInfo)

    if res:  # check termination first
        # only do the first verification strategy
        curTermResult, curTermTime, testDataInfo, ICEData = firstTerminationVerification()
        # recordTermData(testDataInfo, ICEData)  # just for debug
        TermTimeList.append(curTermTime)
        # if terminating, get results
        if curTermResult == "Termination":
            # get current condition as result
            Result = "Cond-Termination"
            final_condition = sstr(cur_condition).replace("|", "||").replace("&", "&&").replace('~', '!').lower()
            break
        else:
            if dataSharePara['DataSaving']:
                recordTermData(testDataInfo, ICEData)
            # taskBplPath = os.path.join(task_nledir, taskName, '{}.bpl'.format(taskName))
            # taskCPath = os.path.join(task_nledir, taskName, '{}.c'.format(taskName))
            # taskOPath = os.path.join(task_nledir, taskName, '{}.o'.format(taskName))
            # if iteration > 1:
            #     taskBplPath = taskBplPath[:-4] + "_assume.bpl"
            #     taskCPath = taskCPath[:-2] + "_assume.c"
            #     taskOPath = taskOPath[:-2] + "_assume.o"
            logger = Logger(printLevel=logLevel)
            logger.LogStatistic()
            it = IceTerm(taskName, task_tmp, taskBplPath, taskOPath, variableInfo, task_ledir, task_nledir, task_test,
                         logger=logger, timeout=10, dataSharePara=dataSharePara, dataSavingPara=dataSavingPara)
            try:
                if dataSharePara['DataSaving']:
                    updateStorageData()
                cur_condition = it.getTerminationCondition(cur_condition, testDataInfo, rsGeneralize)
                NonTermTimeList.append(logger.Stat_NonTermTotalTime)
            except RuntimeError as e:
                logger.Stat_Result = "Runtime Error"
                print(e)
            # record rsl data
            if dataSharePara['DataSaving']:
                filename = taskName
                if iteration > 1:
                    filename += "_assume"
                recordRSLData(filename + '_rsl.bpl')

            benchLogList.append(logger)  # todo
            print('[Info] => Sub-Result: {}'.format(logger.Stat_Result))
            if logger.Stat_Result == 'Verified':
                continue
            else:
                print("Failed to get condition.")
                # do the remaining termination verification
                curTermResult2, curTermTime2, testDataInfo2, ICEData2 = remainingTerminationVerification()
                TermTimeList.append(curTermTime2)
                if curTermResult2 == "Termination":
                    Result = "Cond-Termination"
                    final_condition = sstr(cur_condition).replace("|", "||").replace("&", "&&").replace('~', '!').lower()
                    break
                # recordTermData(testDataInfo2, ICEData2)  # no need to record: already unknown!
                Result = "Unknown"
                break
    else:  # check non-termination first
        # taskBplPath = os.path.join(task_nledir, taskName, '{}.bpl'.format(taskName))
        # taskCPath = os.path.join(task_nledir, taskName, '{}.c'.format(taskName))
        # taskOPath = os.path.join(task_nledir, taskName, '{}.o'.format(taskName))
        # if iteration > 1:
        #     taskBplPath = taskBplPath[:-4] + "_assume.bpl"
        #     taskCPath = taskCPath[:-2] + "_assume.c"
        #     taskOPath = taskOPath[:-2] + "_assume.o"
        logger = Logger(printLevel=logLevel)
        logger.LogStatistic()
        it = IceTerm(taskName, task_tmp, taskBplPath, taskOPath, variableInfo, task_ledir, task_nledir, task_test,
                     logger=logger, timeout=10, dataSharePara=dataSharePara, dataSavingPara=dataSavingPara)
        try:
            if dataSharePara['DataSaving']:
                updateStorageData()
            cur_condition = it.getTerminationCondition(cur_condition, [], rsGeneralize)
            NonTermTimeList.append(logger.Stat_NonTermTotalTime)
        except RuntimeError as e:
            logger.Stat_Result = "Runtime Error"
            print(e)
        # record rsl data
        if dataSharePara['DataSaving']:
            filename = taskName
            if iteration > 1:
                filename += "_assume"
            recordRSLData(filename + '_rsl.bpl')

        benchLogList.append(logger)
        print('[Info] => Sub-Result: {}'.format(logger.Stat_Result))
        if logger.Stat_Result == 'Verified':
            continue
        else:
            curTermResult, curTermTime, testDataInfo, ICEData = overallTerminationVerification()
            TermTimeList.append(curTermTime)
            # if terminating, get results
            if curTermResult == "Termination":
                # get current condition as result
                Result = "Cond-Termination"
                final_condition = sstr(cur_condition).replace("|", "||").replace("&", "&&").replace('~', '!').lower()
                break
            else:
                # recordTermData(testDataInfo)  # no need
                print("Failed to check termination.")
                Result = "Unknown"
                break


Time_Sum = time.time() - total_start_time
TermTime = sum(TermTimeList)
NonTermTime = sum(NonTermTimeList)

print('[Info] Result: {} ({:3f} s, Termination {:3f} s, NonTermination {:3f} s)'.format(Result, Time_Sum, TermTime, NonTermTime))
print('[Info] Condition Result: {}'.format(final_condition))
print('[Info] Iteration times: {}'.format(iteration))
print('[Info] Termination Time Result:')
print(TermTimeList)
print('[Info] NonTermination Time Result:')
print(NonTermTimeList)

LogList.append(benchLogList)

currentTime = datetime.datetime.now().strftime('%Y%m%d%H%M')
