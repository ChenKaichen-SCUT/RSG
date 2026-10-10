from DataInfo import Le_Dir, NLe_Dir, Task_Info, Fixed_Seed, Tmp_Dir, Test_Dir
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
import re
import ast


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


def extract_last_element(input_str):
    # 将字符串转换为列表
    try:
        num_list = ast.literal_eval(input_str)
        if isinstance(num_list, list) and len(num_list) > 0:
            # 提取最后一个元素并转换为字符串
            last_element = str(num_list[-1])
            return last_element
        else:
            return "输入的字符串不是一个非空列表"
    except:
        return "输入的字符串格式不正确"


def decodeResult(Res):
    dict = {}
    pattern1 = r"Result:\s+(\S+)\s+\((\d+\.\d+)\s+s,\s+Termination\s+(\d+\.\d+)\s+s,\s+NonTermination\s+(\d+\.\d+)\s+s\)"
    pattern2 = r"Condition Result: (.*)"
    pattern3 = r"Iteration times:\s+(\d+)"

    match1 = re.search(pattern1, Res[0])

    if match1:
        dict['res'] = match1.group(1)
        dict['sumTime'] = match1.group(2)
        dict['termTime'] = match1.group(3)
        dict['nontermTime'] = match1.group(4)

        # condition = ""
        match2 = re.search(pattern2, Res[1])
        if match2:
            dict['condition'] = match2.group(1).strip()

        # iterTimes = ""
        match3 = re.search(pattern3, Res[2])
        if match3:
            dict['iterTimes'] = match3.group(1).strip()

        termTimeListStr = Res[-4]
        dict['termTimeListStr'] = termTimeListStr
        dict['termTimeLast'] = extract_last_element(termTimeListStr)
        dict['nontermTimeListStr'] = Res[-2]
    else:
        e = ",".join(Res)
        dict['error'] = e
    return dict


if len(sys.argv) == 1:
    raise RuntimeError('Please specify a strategy XML file.')

rootET = ET.parse(sys.argv[1]).getroot()
logLevel = 0
alwaysCompile = True
# import pdb; pdb.set_trace()
strategyList = []
Log_Lgs = None
Log_Excel = None
Log_Dir = os.getcwd()
print('[Info] Setting the strategy...')
for elem in rootET:
    if elem.tag == 'Name':
        print('[Info] Using strategy {}'.format(elem.text))
        continue
    elif elem.tag == 'Log':
        logLevel = int(elem.text)
        continue
    elif elem.tag == 'Log_Lgs':
        Log_Lgs = elem.text
    elif elem.tag == 'Log_Excel':
        Log_Excel = elem.text
    elif elem.tag == 'Log_Dir':
        Log_Dir = elem.text
    elif elem.tag == 'Tmp':
        # Use explicit tmp directory (Support fast tmpfs feature)
        tmpPath = elem.text
        if not os.path.isdir(tmpPath):
            raise RuntimeError(f'Cannot find the tmp directory {tmpPath}')
        Tmp_Dir = os.path.join(tmpPath, 'tmp')
        Test_Dir = os.path.join(tmpPath, 'test')
    elif elem.tag == 'Complie':
        if elem.text in ['Always', 'always', 'ALWAYS']:
            alwaysCompile = True
        else:
            alwaysCompile = False
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


resDictList = []
LogList = []
solvedNum = 0
runNum = 1
currentTime = datetime.datetime.now().strftime('%Y%m%d%H%M')
for bench in Task_Info:
    try:
        # time.sleep(1)
        taskName = bench[0]
        print('[Info] Task {}'.format(taskName))
        variableInfo = '|'.join(bench[1])
        if variableInfo == '':
            variableInfo = '|'

        Commands = ['python3', 'experiment/scripts/CondTerm.py', \
            '--name', taskName, \
            '--ledir', Le_Dir, \
            '--nledir', NLe_Dir, \
            '--vars', variableInfo, \
            '--conf', sys.argv[1]]
            # '--log', f'single.{taskName}']

        process = subprocess.Popen(Commands, stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        stdout, stderr = process.communicate()
        stdoutStr = stdout.decode()
        stderrStr = stderr.decode()
        # print(stdoutStr)
        filepath = 'outputs/' + Log_Excel.replace('TIME', currentTime) + '/' + taskName + '.txt'
        os.makedirs(os.path.dirname(filepath), exist_ok=True)
        with open(filepath, 'w') as file:
            file.write(stdoutStr + "\n\n" + stderrStr)

        print('[Debug]Result:')
        Res = stdoutStr.split('\n')[-8:]
        print(Res)
        resDict = decodeResult(Res)
        resDict['taskName'] = taskName
        resDictList.append(resDict)

        if resDict.get("res") == "Cond-Termination":
            solvedNum += 1

        print('[Info] Solved: {}/{}'.format(solvedNum, runNum))
        runNum += 1
    except Exception as e:
        print('[Error] {}'.format(e))


# currentTime = datetime.datetime.now().strftime('%Y%m%d%H%M')

if Log_Excel != None:
    Log_Excel = Log_Excel.replace('TIME',currentTime)
    attrMakers = [
        ('Task', lambda x: x.get("taskName", "")),
        ('Result', lambda x: x.get("res", "")),
        ('Time', lambda x: x.get("sumTime", "")),
        ('Condition', lambda x: x.get("condition", "")),
        ('Iterations', lambda x: x.get("iterTimes", "")),
        ('TermTime', lambda x: x.get("termTime", "")),
        ('NonTermTime', lambda x: x.get("nontermTime", "")),
        ('TermTimeList', lambda x: x.get("termTimeListStr")),
        ('TermTimeLast', lambda x: x.get("termTimeLast")),
        ('NonTermTimeList', lambda x: x.get("nontermTimeListStr")),
        ('Error', lambda x: x.get("error", ""))
    ]

    Logger.Export2Excel(resDictList, attrMakers, os.path.join(Log_Dir, '{}.xlsx'.format(Log_Excel)))
