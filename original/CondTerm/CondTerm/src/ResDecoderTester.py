import re
import ast

Res = ['[Info] Result: Cond-Termination (36.984713 s, Termination 23.363831 s, NonTermination 5.445166 s)', '[Info] Condition Result: (x <= -1) || (y > 0)',
       '[Info] Iteration times: 2', '[Info] Termination Time Result:', '[15.88910436630249, 7.47472620010376]', '[Info] NonTermination Time Result:', '[5.445166110992432]', '']

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
        return dict

dict = decodeResult(Res)
print(dict)
