clc;
clear;
close all;
%% 创建地图
%地图的大小200*200
MapSizeX = 200 ; 
MapSizeY = 200;
%% 地形地图创建,地图详细参数，请去MapValueFunction.m里面设置
x = 1:1:MapSizeX;
y = 1:1:MapSizeY;
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
%威胁区域中心坐标
ThreatAreaPostion = [140,50];
%威胁区域半径
ThreatAreaRadius = [25];
%将威胁区域叠加到图上

figure
mesh(Map);
hold on;
for i= 1:size(ThreatAreaRadius)
    [X,Y,Z] = cylinder(ThreatAreaRadius(i),50);
    X = X + ThreatAreaPostion(i,1);
    Y = Y + ThreatAreaPostion(i,2);
    Z(2,:) = Z(2,:) + 50;%威胁区域高度
    mesh(X,Y,Z)
end

%% 设置起始点
startPoint = [0,0,20];
endPoint = [200,200,20];
plot3(startPoint(1),startPoint(2),startPoint(3),'ro');
text(startPoint(1),startPoint(2),startPoint(3),'Starting point')
plot3(endPoint(1),endPoint(2),endPoint(3),'r*');
text(endPoint(1),endPoint(2),endPoint(3),'Destination')
title('Map information')
%% 算法参数设置
NodesNumber = 2;%起点与终点之间节点的个数
dim = 2*NodesNumber; %维度，一组坐标点为[x,y,z]3个值，,其中X等间隔分布，所以总的数据个数为2*NodesNumber
lb = [20.*ones(1,NodesNumber),0.*ones(1,NodesNumber)];%x,y,z的下限[20,20,0]
ub = [180.*ones(1,NodesNumber),50.*ones(1,NodesNumber)];%x,y,z的上限[200,200,50]
fobj = @(x)fun(x,NodesNumber,startPoint,endPoint,ThreatAreaPostion,ThreatAreaRadius);%适应度函数
SearchAgents_no=70; % 种群数量
SearchAgents_no_new=300; % 种群数量
Max_iteration=80; % 设定最大迭代次数

% 运行算法多次并记录每次运行的最佳适应度值和运行时间
num_runs = 10;
best_scores_ISSA = zeros(num_runs, 1);
best_scores_SSA = zeros(num_runs, 1);
best_scores_WOA = zeros(num_runs, 1);
best_scores_GWO = zeros(num_runs, 1);
best_scores_SAA = zeros(num_runs, 1);
time_ISSA = zeros(num_runs, 1);
time_SSA = zeros(num_runs, 1);
time_WOA = zeros(num_runs, 1);
time_GWO = zeros(num_runs, 1);
time_SAA = zeros(num_runs, 1);

for i = 1:num_runs
    tic;
    [~, Best_score_ISSA, ~] = ISSA(SearchAgents_no, Max_iteration, lb, ub, dim, fobj);
    time_ISSA(i) = toc;
    best_scores_ISSA(i) = Best_score_ISSA;

    tic;
    [~, Best_score_SSA, ~] = SSA(SearchAgents_no, Max_iteration, lb, ub, dim, fobj);
    time_SSA(i) = toc;
    best_scores_SSA(i) = Best_score_SSA;

    tic;
    [~, Best_score_WOA, ~] = WOA(SearchAgents_no, Max_iteration, lb, ub, dim, fobj);
    time_WOA(i) = toc;
    best_scores_WOA(i) = Best_score_WOA;

    tic;
    [~, Best_score_GWO, ~] = GWO(SearchAgents_no_new, Max_iteration, lb, ub, dim, fobj);
    time_GWO(i) = toc;
    best_scores_GWO(i) = Best_score_GWO;

    tic;
    [~, Best_score_SAA, ~] = SAA(SearchAgents_no, Max_iteration, lb, ub, dim, fobj);
    time_SAA(i) = toc;
    best_scores_SAA(i) = Best_score_SAA;
end

% 计算所有两两算法之间的 Wilcoxon 检验的 p 值
p_values = zeros(5, 5);
algorithms = {'ISSA', 'SSA', 'WOA', 'GWO', 'SAA'};

for i = 1:5
    for j = i+1:5
        p_values(i, j) = ranksum(best_scores_ISSA, best_scores_SSA);
        p_values(j, i) = p_values(i, j); % 因为 p 值是对称的
    end
end

% 显示 p 值矩阵
disp('Wilcoxon 检验的 p 值矩阵：');
disp(p_values);

% 显示平均运行时间
avg_time_ISSA = mean(time_ISSA);
avg_time_SSA = mean(time_SSA);
avg_time_WOA = mean(time_WOA);
avg_time_GWO = mean(time_GWO);
avg_time_SAA = mean(time_SAA);

% 显示平均适应度
avg_Best_ISSA = mean(best_scores_ISSA);
avg_Best_SSA = mean(best_scores_SSA);
avg_Best_WOA = mean(best_scores_WOA);
avg_Best_GWO = mean(best_scores_GWO);
avg_Best_SAA = mean(best_scores_SAA);

% 显示平均适应度
Best_ISSA = min(best_scores_ISSA);
Best_SSA = min(best_scores_SSA);
Best_WOA = min(best_scores_WOA);
Best_GWO = min(best_scores_GWO);
Best_SAA = min(best_scores_SAA);

disp(['平均适应度 (ISSA): ', num2str(avg_Best_ISSA) ]);
disp(['平均适应度 (SSA): ', num2str(avg_Best_SSA)]);
disp(['平均适应度 (WOA): ', num2str(avg_Best_WOA)]);
disp(['平均适应度 (GWO): ', num2str(avg_Best_GWO)]);
disp(['平均适应度 (SAA): ', num2str(avg_Best_SAA)]);

disp(['平均运行时间 (ISSA): ', num2str(avg_time_ISSA), ' 秒']);
disp(['平均运行时间 (SSA): ', num2str(avg_time_SSA), ' 秒']);
disp(['平均运行时间 (WOA): ', num2str(avg_time_WOA), ' 秒']);
disp(['平均运行时间 (GWO): ', num2str(avg_time_GWO), ' 秒']);
disp(['平均运行时间 (SAA): ', num2str(avg_time_SAA), ' 秒']);


% 绘制最优适应度值柱状图
Best_scores = [Best_ISSA, Best_SSA, Best_WOA, Best_GWO, Best_SAA];
algorithms = {'ISSA', 'SSA', 'WOA', 'GWO', 'SAA'};
colors = [1 0 0; 1 1 0; 0 0 0; 0 1 0; 0 0 1]; % 红、黄、黑、绿、蓝

figure(3)
b = bar(Best_scores, 'FaceColor', 'flat');
for k = 1:length(b.CData)
    b.CData(k, :) = colors(k, :);
end
set(gca, 'XTickLabel', algorithms);
ylabel('Best Score');
title('Best Scores of Different Algorithms');
grid on;

% 绘制平均运行时间柱状图
avg_times = [avg_time_ISSA, avg_time_SSA, avg_time_WOA, avg_time_GWO, avg_time_SAA];
figure(4)
b = bar(avg_times, 'FaceColor', 'flat');
for k = 1:length(b.CData)
    b.CData(k, :) = colors(k, :);
end
set(gca, 'XTickLabel', algorithms);
ylabel('Average Time (seconds)');
title('Average Running Time of Different Algorithms');
grid on;

