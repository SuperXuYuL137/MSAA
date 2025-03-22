
%%
clear
clc
close all
addpath(genpath(pwd));
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
NodesNumber = 6; % 起点与终点之间节点的个数
dim = 2 * NodesNumber; % 维度，一组坐标点为[x, y, z]3个值，其中X等间隔分布，所以总的数据个数为2*NodesNumber
lb = [20.*ones(1, NodesNumber), 0.*ones(1, NodesNumber)]; % x, y, z的下限[20, 20, 0]
ub = [180.*ones(1, NodesNumber), 50.*ones(1, NodesNumber)]; % x, y, z的上限[200, 200, 50]
fobj = @(x)fun(x, NodesNumber, startPoint, endPoint, ThreatAreaPostion, ThreatAreaRadius); % 适应度函数
SearchAgents_no = 70; % 种群数量
Max_iteration = 100; % 设定最大迭代次数
number=1; %选定优化函数，自行替换:F1~F10
lower_bound=lb;upper_bound=ub;variables_no=dim;fobj;
pop_size=SearchAgents_no;                      % population members 
max_iter=Max_iteration;                  % maximum number of iteration
%% SCSO
[~,SCSO_Best_score,SCSO_curve]=SCSO(pop_size,max_iter,lower_bound,upper_bound,variables_no,fobj,22);  % Calculating the solution of the given problem using ASFSSA 
display(['The best optimal value of the objective funciton found by SCSO  for ' [num2str(number)],'  is : ', num2str(SCSO_Best_score)]);
%% WOA
[~,WOA_Best_score,WOA_curve]=WOA(pop_size,max_iter,lower_bound,upper_bound,variables_no,fobj,22);
display(['The best optimal value of the objective funciton found by WOA  for ' [num2str(number)],'  is : ', num2str(WOA_Best_score)]);
%% PSO
[~,PSO_Best_score,PSO_curve]=PSO(pop_size,max_iter,lower_bound,upper_bound,variables_no,fobj,22);
display(['The best optimal value of the objective funciton found by PSO  for ' [num2str(number)],'  is : ', num2str(PSO_Best_score)]);
%% GWO
[~,GWO_Best_score,GWO_curve]=GWO(pop_size,max_iter,lower_bound,upper_bound,variables_no,fobj,22);
display(['The best optimal value of the objective funciton found by GWO  for ' [num2str(number)],'  is : ', num2str(GWO_Best_score)]);
%% SAA
[~,SAA_Best_score,SAA_curve]=SAA(pop_size/10,max_iter,lower_bound,upper_bound,variables_no,fobj,22);
display(['The best optimal value of the objective funciton found by SAA  for ' [num2str(number)],'  is : ', num2str(SAA_Best_score)]);
%% MSAA
[~,MSAA_Best_score,MSAA_curve]=MSAA(pop_size,max_iter,lower_bound,upper_bound,variables_no,fobj,22);
display(['The best optimal value of the objective funciton found by MSAA  for ' [num2str(number)],'  is : ', num2str(MSAA_Best_score)]);
%% MSAA
[~,ISAA_Best_score,ISAA_curve]=ISAA(pop_size,max_iter,lower_bound,upper_bound,variables_no,fobj,4);
display(['The best optimal value of the objective funciton found by i=ISAA  for ' [num2str(number)],'  is : ', num2str(ISAA_Best_score)]);
%% Figure
figure
CNT=50;
k=round(linspace(1,max_iter,CNT)); %随机选CNT个点
% 注意：如果收敛曲线画出来的点很少，随机点很稀疏，说明点取少了，这时应增加取点的数量，100、200、300等，逐渐增加
% 相反，如果收敛曲线上的随机点非常密集，说明点取多了，此时要减少取点数量
iter=1:1:max_iter;
    semilogy(iter(k),SCSO_curve(k),'b-^','linewidth',1);
    hold on
    semilogy(iter(k),WOA_curve(k),'m-*','linewidth',1);
    hold on
    semilogy(iter(k),PSO_curve(k),'y-p','linewidth',1);
    hold on
    semilogy(iter(k),GWO_curve(k),'c-s','linewidth',1);
    hold on
    semilogy(iter(k), SAA_curve(k), 'g-o', 'linewidth', 1); % 添加SAA的曲线
    hold on
    semilogy(iter(k), MSAA_curve(k), 'k-d', 'linewidth', 1); % 添加MSAA的曲线
    hold on
    semilogy(iter(k), ISAA_curve(k), 'r-d', 'linewidth', 1); % 添加MSAA的曲线
grid on;
title('收敛曲线')
xlabel('迭代次数');
ylabel('适应度值');
box on
legend('SCSO','WOA','PSO','GWO','SAA','MSAA','ISAA')
% 这里将图形设置为正方形
set (gcf,'position', [300, 300, 500, 500]) % 修改图形窗口为正方形

rmpath(genpath(pwd))