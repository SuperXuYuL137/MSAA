%% 基于雪崩搜索算法的三维无人机航迹优化
clc;
clear;
close all;

%% 创建地图
% 地图的大小200*200
MapSizeX = 200;
MapSizeY = 200;
sums=0;
avgs=0;
Function_name='UAV';
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
ThreatAreaPostion = [140, 50];
% 威胁区域半径
ThreatAreaRadius = [25];

% 将威胁区域叠加到图上
figure
set(gcf, 'Color', 'white');  % 将背景设置为白色
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

label=(1:1:10);

runs = 5;%遍历次数

Best_score = zeros(1,runs);


Best_score_pro = zeros(1, length(label));
Best_pos_pro = cell(1, length(label));
Cong_Curve_pro = cell(1, length(label));
sums_pro = zeros(1, length(label));
avgs_pro = zeros(1, length(label));
tle = cell(1, length(label));

%% GOOSE
for i=1:10     %运行5次
[Best_pos,Best_score,Cong_Curve]=SAA(SearchAgents_no, Max_iteration, lb, ub, dim, fobj, 22);
Best_basic(i) = Best_score; 
display( num2str(Best_score));       
sums=sums+Best_score;
avgs=sums/5;  %平均值
[avgs]
end
display( num2str(avgs));
%% MSAA 
for i = 1:1
    for j = 1:length(label)
        [Best_pos_pro{j},Best_score_pro(j),  Cong_Curve_pro{j}] = MSAA(SearchAgents_no,Max_iteration,lb,ub,dim,fobj,label(j));
        sums_pro(j) = sums_pro(j) + Best_score_pro(j);
        avgs_pro(j) = sums_pro(j)/5;
        tle{j} = Map_name(j);
    end
end

%% 画函数图
load('color_list')
color_all=color_list(randperm(length(color_list)),:);


%% 画改进对比
figure;
set(gcf, 'Color', 'white');  % 将背景设置为白色
hold on;
%先画出SAA的迭代曲线图
Best_sore = min(Best_basic);
Best_min = min(Best_score, min(Best_score_pro));
semilogy(Cong_Curve, 'Color', 'r', 'DisplayName', 'MSAA','LineWidth',1);
title('Convergence curve');
xlabel('Iteration');
ylabel('Best score obtained so far');
ylim([100,Best_min]);

% 绘制各个标签对应的收敛曲线
for m = 1:length(label)
    semilogy(Cong_Curve_pro{m},'Color',color_all(m,:),'LineWidth',1, 'DisplayName', (['MSAA', '-', tle{m}]));
end
legend('Location', 'BestOutside');
grid off;
box on;
%