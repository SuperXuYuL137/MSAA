%% 基于雪崩搜索算法的三维无人机航迹优化
clc;
clear;
close all;

%% 创建地图
% 地图的大小200*200
MapSizeX = 200;
MapSizeY = 200;

%% 地形地图创建, 地图详细参数，请去MapValueFunction.m里面设置
x = 1:1:MapSizeX;
y = 1:1:MapSizeY;
Map = zeros(MapSizeX, MapSizeY); % 预分配地图矩阵
for i = 1:MapSizeX
    for j = 1:MapSizeY
        Map(i,j) = MapValueFunction(i,j);
    end
end

global NodesNumber
global startPoint
global endPoint
global ThreatAreaPostion
global ThreatAreaRadius

%% 威胁区域绘制
% 威胁区域中心坐标
ThreatAreaPostion = [140, 50; 45, 150; 100, 100];
% 威胁区域半径
ThreatAreaRadius = [25, 20, 35];

% 将威胁区域叠加到图上
figure
mesh(Map);
hold on;
threat_handles = cell(1, length(ThreatAreaRadius)); % 使用单元数组存储句柄
for i = 1:length(ThreatAreaRadius)
    [X, Y, Z] = cylinder(ThreatAreaRadius(i), 50);
    X = X + ThreatAreaPostion(i, 1);
    Y = Y + ThreatAreaPostion(i, 2);
    Z(2,:) = Z(2,:) + 50; % 威胁区域高度
    h = mesh(X, Y, Z);
    h.FaceColor = 'blue'; % 设置圆柱体的面颜色为蓝色
    h.EdgeColor = 'none'; % 设置圆柱体的边缘颜色为无
    threat_handles{i} = h; % 保存句柄
end

%% 初始化存储运行时间的数组
algorithm_names = {'SAA', 'WOA', 'GWO', 'MSAA', 'PSO', 'SCSO'};
execution_times = zeros(1, numel(algorithm_names));
num_runs = 10;

% 初始化结果存储
Best_scores = zeros(num_runs, numel(algorithm_names));
Best_positions = cell(num_runs, numel(algorithm_names));

%% 设置起始点
startPoint = [0, 0, 20];
endPoint = [200, 200, 20];
plot3(startPoint(1), startPoint(2), startPoint(3), 'ro');
text(startPoint(1), startPoint(2), startPoint(3), 'Starting point')
plot3(endPoint(1), endPoint(2), endPoint(3), 'r*');
text(endPoint(1), endPoint(2), endPoint(3), 'Destination')
title('Map information')

%% 算法参数设置
NodesNumber = 2; % 起点与终点之间节点的个数
dim = 2 * NodesNumber; % 维度，一组坐标点为[x, y, z]3个值，其中X等间隔分布，所以总的数据个数为2*NodesNumber
lb = [20.*ones(1, NodesNumber), 0.*ones(1, NodesNumber)]; % x, y, z的下限[20, 20, 0]
ub = [180.*ones(1, NodesNumber), 50.*ones(1, NodesNumber)]; % x, y, z的上限[200, 200, 50]
fobj = @(x)fun(x, NodesNumber, startPoint, endPoint, ThreatAreaPostion, ThreatAreaRadius); % 适应度函数
SearchAgents_no = 70; % 种群数量
Max_iteration = 80; % 设定最大迭代次数

%% 多次运行算法并记录结果
for run = 1:num_runs
    % 雪崩算法
    tic;
    [Best_pos_SAA, Best_score_SAA, SAA_curve] = SAA(SearchAgents_no, Max_iteration, lb, ub, dim, fobj, 22);
    execution_times(1) = execution_times(1) + toc;
    Best_scores(run, 1) = Best_score_SAA;
    Best_positions{run, 1} = Best_pos_SAA;

    % 鲸鱼算法
    tic;
    [Best_pos_WOA, Best_score_WOA, WOA_curve] = WOA(SearchAgents_no, Max_iteration, lb, ub, dim, fobj, 22);
    execution_times(2) = execution_times(2) + toc;
    Best_scores(run, 2) = Best_score_WOA;
    Best_positions{run, 2} = Best_pos_WOA;

    % 灰狼算法
    tic;
    [Best_pos_GWO, Best_score_GWO, GWO_curve] = GWO(SearchAgents_no, Max_iteration, lb, ub, dim, fobj, 22);
    execution_times(3) = execution_times(3) + toc;
    Best_scores(run, 3) = Best_score_GWO;
    Best_positions{run, 3} = Best_pos_GWO;

    % 混合策略雪崩算法
    tic;
    [Best_pos_MSAA, Best_score_MSAA, MSAA_curve] = MSAA(SearchAgents_no, Max_iteration, lb, ub, dim, fobj, 22);
    execution_times(4) = execution_times(4) + toc;
    Best_scores(run, 4) = Best_score_MSAA;
    Best_positions{run, 4} = Best_pos_MSAA;

    % 粒子群优化
    tic;
    [Best_pos_PSO, Best_score_PSO, PSO_curve] = PSO(SearchAgents_no, Max_iteration, lb, ub, dim, fobj, 22);
    execution_times(5) = execution_times(5) + toc;
    Best_scores(run, 5) = Best_score_PSO;
    Best_positions{run, 5} = Best_pos_PSO;

    % 沙猫优化
    tic;
    [Best_pos_SCSO, Best_score_SCSO, SCSO_curve] = SCSO(SearchAgents_no, Max_iteration, lb, ub, dim, fobj, 22);
    execution_times(6) = execution_times(6) + toc;
    Best_scores(run, 6) = Best_score_SCSO;
    Best_positions{run, 6} = Best_pos_SCSO;
end

% 计算平均运行时间
execution_times = execution_times / num_runs;

% 计算统计量
avg_scores = mean(Best_scores);
std_scores = std(Best_scores);
min_scores = min(Best_scores);
max_scores = max(Best_scores);

%% 输出结果
fprintf('Algorithm\t\tMean\t\tStd\t\tMin\t\tMax\t\tTime\n');
for i = 1:numel(algorithm_names)
    fprintf('%s\t\t%.4f\t%.4f\t%.4f\t%.4f\t%.4f\n', algorithm_names{i}, avg_scores(i), std_scores(i), min_scores(i), max_scores(i), execution_times(i));
end
