from RSLearner import RSLearner
from Logger import Logger  #pylint: disable=import-error
from sympy import *

def calculateCondition(rs):
    expr_strs = rs.split("&&")
    exprs = []
    for str in expr_strs:
        expr = parse_expr(str)
        exprs.append(expr)
    rs_expr = And(*exprs)
    sim_rs_expr = simplify(rs_expr)
    condition = ~sim_rs_expr
    sim_condition = simplify(condition)
    return sim_condition


if __name__ == "__main__":
    originFile = 'experiment/benchmarks-Instrumented/test_01/test_01.bpl'
    tmpDir = 'tmpfs/tmp'
    tempFile = 'tmpfs/tmp/test_01.bpl'
    rsl = RSLearner(Logger(), ['x', 'y'], originFile, tmpDir, tempFile)
    rsl.GenerateRSLBplFile()
    rsResult = rsl.ExecuteRSL()
    print(rsResult)

    if rsResult['Result'] == 'Verified':
        rs = rsResult['RS']
        print('get recurrent set: ', rs)
        # save result, simplify rs formula
        condition = calculateCondition(rs)
        print('condition: ', condition)
