import os
import re
import subprocess
import shutil
from functools import reduce
import antlr4
from antlr4.Token import CommonToken
from antlr4.tree.Tree import TerminalNodeImpl
import sys
sys.path.append(os.path.abspath('src'))

from BoogieAST.AST2SourceVisitor import AST2SourceVisitor #pylint: disable=import-error
from BoogieAST.ASTOperation import ASTOperation #pylint: disable=import-error
from BoogieAST.BoogieLexer import BoogieLexer #pylint: disable=import-error
from BoogieAST.BoogieParser import BoogieParser #pylint: disable=import-error


class RSLearner:

    def __init__(self, logger, vars, oriFile, tmpDir, tempfile, mDataPath="", rsGeneralize=False, dataSharePara={}):
        self.Logger = logger
        self.Vars = vars
        self.oriFile = oriFile
        self.tmpDir = tmpDir
        self.storageDir = tmpDir[:-3]
        self.storageCSV = os.path.join(self.storageDir, 'storage.csv')
        self.storageIMP = os.path.join(self.storageDir, 'storage.imp')
        self.tempfile = tempfile
        self.TermRe = r'(.*)%(.*)%(.*)'
        self.InvRe = r'(.*)invariant(.*)'
        self.mDataPath = mDataPath
        self.rsGeneralize = rsGeneralize
        self.DS = dataSharePara['DataSaving']
        self.DSRatio = 10

        self.fileName = None
        self.projectDir = '/'.join(os.getcwd().split('/'))
        self.boogieDir = self.projectDir + '/ice/popl16_artifact/Boogie/Binaries'
        self.boogieArgs = ['/nologo', '/noinfer', '/contractInfer', '/mlHoudini:dt_penalty', '/RSInfer', '/trace', '/printAssignment']
        if self.rsGeneralize:
            self.boogieArgs.append('/RSGeneralize')
        # DataSharing
        if self.DS:
            self.boogieArgs = self.boogieArgs + ['/DataShare', str(self.DSRatio), '/StorageCSV', str(self.storageCSV), '/StorageIMP', str(self.storageIMP)]

        # # mData
        # if self.mDataPath != "":
        #     self.boogieArgs = self.boogieArgs + ['/mData', self.mDataPath]

        if self.Logger.SMTFile != None:
            self.boogieArgs.append('/proverLog:{}'.format(self.Logger.SMTFile))

        fileName = self.oriFile.split('/')[-1].strip()
        # fileName = fileName.split('.')[0] + '_rsl.' + fileName.split('.')[1]
        fileName = fileName[:-4] + '_rsl.bpl'
        if not os.path.exists(self.tmpDir):
            os.makedirs(self.tmpDir)
        outFile = os.path.join(self.tmpDir, fileName)
        self.fileName = outFile

    def CleanTmpFiles(self):
        if os.path.exists(self.tmpDir) and os.path.isdir(self.tmpDir):
            shutil.rmtree(self.tmpDir)

    def ExecuteRSL(self, timeout=None, timeoutMonitor=None):
        curDir = os.path.abspath('.')
        os.chdir(self.boogieDir)
        self.Logger.Log('[Debug] Boogie Dir: {}'.format(self.boogieDir))
        command = ['mono', 'Boogie.exe'] + self.boogieArgs + [self.fileName]
        if timeout != None:
            command = [timeoutMonitor, '--foreground', '--kill-after', '1', str(int(timeout) + 1)] + command
            self.Logger.StartTimer('TOM@RSL')
        self.Logger.Log('[Debug] Boogie Cmd: {}'.format(reduce(lambda x, y: '{} {}'.format(x, y), command)))
        process = subprocess.Popen(command,
                                   stdout=subprocess.PIPE,
                                   stderr=subprocess.PIPE)
        os.chdir(curDir)

        # stdout, stderr = process.communicate()
        #
        # print(stdout.decode())
        # stdoutLines = stdout.decode().split('\n')
        #
        stdoutLines = []
        nextIsRec = False
        recIt = 0
        finish = False
        recLine = ""
        conditionLine = ""
        rsGeneralized = False
        conditionLearned = False
        while process.poll() == None:
        # while True:
            # print(process.returncode)
            if timeout != None and self.Logger.CalcTimePass('TOM@RSL') > timeout:
                process.kill()
                print('[Info] Process killed.')
                self.Logger.Log('[Info] Benchmark timeout!')
                return {'Result': 'Timeout'}
            line = process.stdout.readline().decode().strip()
            if line.startswith('\n') or line == '':
                continue
            stdoutLines.append(line)
            if line.startswith('[Debug]') or line.startswith('[Warning]') or line.startswith(
                    '[Info]') or line.startswith('[Error]'):
                self.Logger.Log(line)
            if line.startswith('Prover time = '):
                proverTime = float(line[len('Prover time = '):].strip())
                self.Logger.Log('[Info] => Prover Time: {}'.format(proverTime))
                if self.Logger.Stat:
                    self.Logger.Stat_RSLProverTimeTotal += proverTime
                    self.Logger.Stat_RSLProverTimeList.append(proverTime)
            if line.startswith('C5 Learner time = '):
                learnerTime = float(line[len('C5 Learner time = '):].strip())
                self.Logger.Log('[Info] => Learner Time: {}'.format(learnerTime))
                if self.Logger.Stat:
                    self.Logger.Stat_RSLLearnerTimeTotal += learnerTime
                    self.Logger.Stat_RSLLearnerTimeList.append(learnerTime)
                finish = True
            if line.startswith('[INFO] Current RS: '):
                recLine = line[19:].strip()
            if line.startswith('[INFO] Generalized RS: '):
                recLine = line[23:].strip()
                rsGeneralized = True
            if nextIsRec:
                self.Logger.Log('[Info] Guess Rec #{}: {}'.format(recIt, line))
                recIt += 1
                nextIsRec = False
            if line.startswith('{') and not finish:
                nextIsRec = True
        # import pdb; pdb.set_trace()
        if self.Logger.Stat:
            self.Logger.Stat_RecRefineNumList.append(recIt - 1)
        if len(stdoutLines) == 0:
            if timeout != None:
                self.Logger.Log('[Info] Benchmark timeout!')
                return {'Result': 'Timeout'}
            else:
                raise RuntimeError('No stdoutput!')
        resultLine = stdoutLines[-1]
        self.Logger.Log(resultLine)
        reMatcher = r'Boogie program verifier finished with (\d+) verified, (\d+) error(s)?'
        reResult = re.search(reMatcher, resultLine)
        if reResult == None:
            reMatcher = r'Boogie program verifier exited with error detected at (.*):(.*)'
            reResult = re.search(reMatcher, resultLine)

            if reResult == None:
                if timeout != None and self.Logger.CalcTimePass('TOM@RSL') > timeout - 2:
                    # import pdb; pdb.set_trace()
                    self.Logger.Log('[Info] Benchmark timeout!')
                    return {'Result': 'Timeout'}
                self.Logger.Log('RSL Error Info:', level=0)
                self.Logger.Log('{}'.format(reduce(lambda x, y: '{}\n{}'.format(x, y), stdoutLines)), level=0)
                print('{}'.format(reduce(lambda x, y: '{}\n{}'.format(x, y), stdoutLines)))
                raise RuntimeError('RSL Runtime Error！')
            return {'Result': 'Failed-RSL', 'Error': list(reResult.group(2).split(','))}

        verifiedNum = int(reResult.group(1))
        errorNum = int(reResult.group(2))
        if errorNum == 0:
            return {'Result': 'Verified', 'RS': recLine, 'RSGeneralized': rsGeneralized, 'Condition': conditionLine, 'ConditionLearned': conditionLearned}
        else:
            return {'Result': 'Failed'}

    def GenerateRSLBplFile(self):
        # duplicate remove
        fileOpen = open(self.oriFile)
        outFileOpen = open(self.fileName, 'w')
        tempContent = fileOpen.readlines()
        fileOpen.close()
        for line in tempContent:
            invResult = re.search(self.InvRe, line)
            if not invResult is None:
                continue
            result = re.search(self.TermRe, line)
            if not result is None:
                if 'function' in line:
                    continue
                strList = line.split('%')
                newLine = strList[0] + strList[2]
                if 'assume()' in newLine:
                    continue
                if newLine.strip() == '':
                    continue
                outFileOpen.write(newLine)
            else:
                outFileOpen.write(line)
        outFileOpen.close()
