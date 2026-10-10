# from z3 import *
from sympy import *
import re

# Z3: not very good
# x = Int('x')
# y = Int('y')
# # bool_expr = And(-2<y, 0<x, -1<y)
# bool_expr = ((x + y)**2 - (x - y)**2)/(2*y)
# print(bool_expr)
#
# simplified_expr = simplify(bool_expr)
# print(simplified_expr)

# sympy:
# x, y = symbols('x y')
# expr_str = "-2 < y & 0 < x & -1 < y"  # cannot be parsed
# expr_str = " -2 < y "
# expr = parse_expr(expr_str)
# print(expr)
# expr2 = simplify(expr_str)
# print(expr2)

# bool_expr = ((x + y)**2 - (x - y)**2)/(2*y)
# bool_expr = And(-2<y, 0<x, -1<y)
# print(bool_expr)
# simplified_expr = simplify(bool_expr)
# print(simplified_expr)

# true
# true_expr = parse_expr("0==0")
# print(true_expr)
# true_str = sstr(true_expr)
# print(true_str)
#
# expr_strs = ["-2 < y ", "0 < x ", "-1 < y"]
# exprs = []
# for str in expr_strs:
#     expr = parse_expr(str)
#     exprs.append(expr)
# bool_expr = And(*exprs)
# print(bool_expr)
# bool_expr = And(bool_expr, true_expr)
# print(bool_expr)
# sim_expr = simplify(bool_expr)
# print(sim_expr)
# not_expr = ~sim_expr
# print(not_expr)
# sim_not_expr = simplify(not_expr)
# print(sim_not_expr)

# str = sstr(sim_not_expr)
# print(str)

# 0707
# rs = '-1 < x && -1 < y'
# rs_str = rs.replace('&&', '&').replace('||', '|')
# pattern = re.compile(r'\b[A-Za-z_][A-Za-z0-9_]*\b')
# vars = set(pattern.findall(rs_str))
# local_dict = {var: symbols(vars) for var in vars}
# # local_dict.update({'&': And, '|': Or})
# parsed_rs = eval(rs_str, {"__builtins__": None}, local_dict)
# sim_rs_expr = simplify(rs_str, locals=local_dict)
# condition = ~sim_rs_expr
# sim_condition = simplify(condition)
#
#
# # 0711
# def calculateNegation(rs):
#     or_strs = rs.split("||")
#     if len(or_strs) > 1:
#         or_neg_exprs = []
#         for or_str in or_strs:
#             expr = calculateNegation(or_str)
#             or_neg_exprs.append(expr)
#         neg_expr = And(*or_neg_exprs)
#         sim_expr = simplify_logic(neg_expr)
#         return sim_expr
#     else:
#         and_strs = rs.split("&&")
#         and_neg_exprs = []
#         for and_str in and_strs:
#             and_str_strip = and_str.strip()
#             if and_str_strip.count('(') < and_str_strip.count(')'):
#                 and_str_strip = and_str_strip[:-1]
#             elif and_str_strip.count('(') > and_str_strip.count(')'):
#                 and_str_strip = and_str_strip[1:]
#             expr = parse_expr(and_str_strip)
#             neg_expr = ~expr
#             sim_expr = simplify(neg_expr)
#             and_neg_exprs.append(sim_expr)
#         cond_expr = Or(*and_neg_exprs)
#         sim_expr = simplify(cond_expr)
#         return sim_expr
#
#
# def resolveCondition(condition):
#     or_strs = condition.split("||")
#     if len(or_strs) > 1:
#         or_exprs = []
#         for or_str in or_strs:
#             expr = resolveCondition(or_str)
#             or_exprs.append(expr)
#         whole_expr = Or(*or_exprs)
#         sim_expr = simplify(whole_expr)
#         return sim_expr
#     else:
#         and_strs = condition.split("&&")
#         and_exprs = []
#         for and_str in and_strs:
#             and_str_strip = and_str.strip().strip('()')
#             expr = parse_expr(and_str_strip)
#             and_exprs.append(expr)
#         cond_expr = And(*and_exprs)
#         sim_expr = simplify(cond_expr)
#         return sim_expr
#
#
# def analyzeCondition(condition):
#     or_strs = condition.split("||")
#     if len(or_strs) > 1:
#         or_exprs = []
#         for or_str in or_strs:
#             expr = analyzeCondition(or_str)
#             or_exprs.append(expr)
#         rs_expr = Or(*or_exprs)
#         sim_expr = simplify(rs_expr)
#         return sim_expr
#     else:
#         and_strs = condition.split("&&")
#         and_exprs = []
#         for and_str in and_strs:
#             and_str_strip = and_str.strip().strip('()')
#             expr = parse_expr(and_str_strip)
#             and_exprs.append(expr)
#         rs_expr = And(*and_exprs)
#         sim_expr = simplify(rs_expr)
#         return sim_expr


# rs = '(x <= 1 && x <= -1) || (x <= 1 && -1 < x && 0 < x)'
# rs = "-x <= -1 && 49 >= -(x + y)"
# rs = "(t + j <= 120 && -35 >= t - j) || (t - j <= -60 && 134 >= -(t - j)) || (t - j <= -57 && 129 >= -(t - j)) || (t - j <= -46 && 126 >= -(t - j)) || (t - j <= -37 && 115 >= -(t - j)) || (-(t - j) <= 76 && -1 >= t - j) || (t - j <= -29 && 100 >= -(t - j)) || (t - j <= -23 && 98 >= -(t - j)) || (t - j <= -13 && 92 >= -(t - j)) || (t - j <= -1 && 82 >= -(t - j))"
# rs = "(-n <= -2 && j <= 1) || ((j - n <= -1 || (j - n >= 1 && j - n <= 49)) && 50 >= -(j - t)) || ((j - n <= -1 || (j - n >= 1 && j - n <= 49)) && 50 >= -(j - t)) || ((-(j - n) <= -1 || (-(j - n) >= 1 && -(j - n) <= 49)) && 50 >= -(j - t))"
# cond_expr = calculateNegation(rs)
# print(cond_expr)

# condition = "(y <= -2 && y <= -3) || (y <= -2 && -3 < y && x <= 2) || (-2 < y && x <= 0)"
# cond_expr = resolveCondition(condition)
# print(cond_expr)

# cond = "(x > -1) | Ne(y, 0)"
# pattern = r'Ne\(([^,]+),\s*([^)]+)\)'
# result = re.sub(pattern, r'(\1 != \2)', cond)
# print(result)

# cond = "(Abs(t) > 5) & ((t > 1) | (t < -5)) & ((t > 3) | (t < -5))"
# pattern = r'Abs\(([^)]+)\)\s*>\s*([^)\s]+)'
# match = re.search(pattern, cond)
# if match:
#     print(match.group(1))
#     print(match.group(2))
# result = re.sub(pattern, r'(\1 > \2 || \1 < -\2)', cond)
# print(result)

# 20250227-debug
and_str_strip = " -(has - t) <= -1"
expr = parse_expr(and_str_strip)
print(expr)
