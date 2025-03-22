功能概述
Cal_stats.m：统计结果分析，计算均值、标准差、最优值等，并进行显著性检验。
cauchy.m：生成柯西分布随机数。
chaos_density_comparison.m：对比21种混沌映射的概率密度函数。
CreateValidPath.m：生成避开威胁区域的三维无人机有效路径。
fun.m：适应度函数，用于评估无人机路径的优劣。
generate_initial_population.m：基于帐篷映射生成初始种群。
GetThePathLine.m：通过三次样条插值生成平滑路径。
main.m	主程序，对比多种算法的路径优化效果，生成三维路径图、收敛曲线、执行时间对比等。
main1.m	多次运行算法并统计结果（均值、标准差、最优值等）。
main_design.m	针对工程设计问题的优化测试框架，支持多算法对比与结果保存。
fun.m	适应度函数，评估路径长度、高度、转弯角等指标。
CreateValidPath.m	生成有效路径，避开威胁区域。
Cal_stats.m	统计结果分析，输出均值、标准差、显著性检验等。
GetThePathLine.m	通过三次样条插值生成平滑路径坐标。
initialization.m：路径初始化。
ISAA.m：改进雪崩算法（MSAA）。
IsPathOk.m：路径有效性检查。
Map.m：混沌映射生成。
Map_name.m:标明混沌映射的名称
Map_set:调用混沌映射函数
Map_set_test.m:调用函数生成并展示混沌映射的图像
MapValueFunction.m:生成三维地图数据
plotMain.m:画出三维无人机路径规划的迭代图
runsMain.m各函数的最优值 标准差 平均值 中值 最差值 以及wilcoxon秩和检验
XRmain_design.m:用于计算算法的各个测试数据的消融实验
XRtest.m:三维无人机航迹优化的消融实验
数据集说明
input_data22:cec2022测试函数的数据集
