%% 基于雪崩搜索算法的三维无人机航迹优化
%% 
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
ThreatAreaPostion = [];%140, 50;45,150;
%威胁区域半径
ThreatAreaRadius = [];%25,20

% 将威胁区域叠加到图上
figure
mesh(Map);
hold on;
threat_handles = cell(1, length(ThreatAreaRadius)); % 使用单元数组存储句柄
for i= 1:length(ThreatAreaRadius)
    [X,Y,Z] = cylinder(ThreatAreaRadius(i),50);
    X = X + ThreatAreaPostion(i,1);
    Y = Y + ThreatAreaPostion(i,2);
    Z(2,:) = Z(2,:) + 50;%威胁区域高度
    h = mesh(X, Y, Z);
    h.FaceColor = 'blue'; % 设置圆柱体的面颜色为蓝色
    h.EdgeColor = 'none'; % 设置圆柱体的边缘颜色为无
    threat_handles{i} = h; % 保存句柄
end

%% 初始化存储运行时间的数组
algorithm_names = {'SAA', 'WOA', 'GWO', 'MSAA','ABC','PSO','SCSO'};
execution_times = zeros(1, numel(algorithm_names));
set(gcf, 'Color', 'white');  % 将背景设置为白色
%% 设置起始点
startPoint = [0,0,20];
endPoint = [200,200,20];
% startPoint = [0,0,20];
% endPoint = [200,200,100];
plot3(startPoint(1),startPoint(2),startPoint(3),'ro');
text(startPoint(1),startPoint(2),startPoint(3),'Starting point')
plot3(endPoint(1),endPoint(2),endPoint(3),'r*');
text(endPoint(1),endPoint(2),endPoint(3),'Destination')
title('Map information')
%% 算法参数设置
% NodesNumber = 2;%起点与终点之间节点的个数   %3,6,8，13，14,19
% dim = 2*NodesNumber; %维度，一组坐标点为[x,y,z]3个值，,其中X等间隔分布，所以总的数据个数为2*NodesNumber
% lb = [20.*ones(1,NodesNumber),0.*ones(1,NodesNumber)];%x,y,z的下限[20,20,0]
% ub = [200.*ones(1,NodesNumber),50.*ones(1,NodesNumber)];%x,y,z的上限[200,200,50]
% fobj = @(x)fun(x,NodesNumber,startPoint,endPoint,ThreatAreaPostion,ThreatAreaRadius);%适应度函数
SearchAgents_no=80; % 种群数量
SearchAgents_no_new=30; % 种群数量
Max_iteration=80; % 设定最大迭代次数
%改进麻雀寻优
% [Best_pos_ISSA,Best_score_ISSA,ISSA_curve]=ISSA(SearchAgents_no,Max_iteration,lb,ub,dim,fobj,22);
%原雪崩算法寻优
tic;
NodesNumber = 6;%起点与终点之间节点的个数   %3,6,8，13，14,19
dim = 2*NodesNumber; %维度，一组坐标点为[x,y,z]3个值，,其中X等间隔分布，所以总的数据个数为2*NodesNumber
lb = [20.*ones(1,NodesNumber),0.*ones(1,NodesNumber)];%x,y,z的下限[20,20,0]
ub = [200.*ones(1,NodesNumber),50.*ones(1,NodesNumber)];%x,y,z的上限[200,200,50]
fobj = @(x)fun(x,NodesNumber,startPoint,endPoint,ThreatAreaPostion,ThreatAreaRadius);%适应度函数
[Best_pos_SAA,Best_score_SAA,SAA_curve]=SAA(SearchAgents_no,Max_iteration,lb,ub,dim,fobj,22);
execution_times(1) = toc;
%鲸鱼寻优
tic;
NodesNumber = 6;%起点与终点之间节点的个数   %3,6,8，13，14,19
dim = 2*NodesNumber; %维度，一组坐标点为[x,y,z]3个值，,其中X等间隔分布，所以总的数据个数为2*NodesNumber
lb = [20.*ones(1,NodesNumber),0.*ones(1,NodesNumber)];%x,y,z的下限[20,20,0]
ub = [200.*ones(1,NodesNumber),50.*ones(1,NodesNumber)];%x,y,z的上限[200,200,50]
fobj = @(x)fun(x,NodesNumber,startPoint,endPoint,ThreatAreaPostion,ThreatAreaRadius);%适应度函数
[Best_pos_WOA,Best_score_WOA,WOA_curve]=WOA(SearchAgents_no,Max_iteration,lb,ub,dim,fobj,22);
execution_times(2) = toc;
%灰狼寻优
tic;
NodesNumber = 6;%起点与终点之间节点的个数   %3,6,8，13，14,19
dim = 2*NodesNumber; %维度，一组坐标点为[x,y,z]3个值，,其中X等间隔分布，所以总的数据个数为2*NodesNumber
lb = [20.*ones(1,NodesNumber),0.*ones(1,NodesNumber)];%x,y,z的下限[20,20,0]
ub = [200.*ones(1,NodesNumber),50.*ones(1,NodesNumber)];%x,y,z的上限[200,200,50]
fobj = @(x)fun(x,NodesNumber,startPoint,endPoint,ThreatAreaPostion,ThreatAreaRadius);%适应度函数
[Best_pos_GWO,Best_score_GWO,GWO_curve]=GWO(SearchAgents_no,Max_iteration,lb,ub,dim,fobj,22);
execution_times(3) = toc;
%混合策略雪崩寻优
tic;
NodesNumber = 2;%起点与终点之间节点的个数   %3,6,8，13，14,19
dim = 2*NodesNumber; %维度，一组坐标点为[x,y,z]3个值，,其中X等间隔分布，所以总的数据个数为2*NodesNumber
lb = [20.*ones(1,NodesNumber),0.*ones(1,NodesNumber)];%x,y,z的下限[20,20,0]
ub = [200.*ones(1,NodesNumber),50.*ones(1,NodesNumber)];%x,y,z的上限[200,200,50]
fobj = @(x)fun(x,NodesNumber,startPoint,endPoint,ThreatAreaPostion,ThreatAreaRadius);%适应度函数
[Best_pos_ISAA,Best_score_ISAA,ISAA_curve] = ISAA(SearchAgents_no,Max_iteration,lb,ub,dim,fobj,4);  %2,6,7,9,11,12,13,14,15,16,18,19,20,21
execution_times(4) = toc/6;
% 人工蜂群寻优
tic;
NodesNumber = 3;%起点与终点之间节点的个数   %3,6,8，13，14,19
dim = 2*NodesNumber; %维度，一组坐标点为[x,y,z]3个值，,其中X等间隔分布，所以总的数据个数为2*NodesNumber
lb = [20.*ones(1,NodesNumber),0.*ones(1,NodesNumber)];%x,y,z的下限[20,20,0]
ub = [200.*ones(1,NodesNumber),50.*ones(1,NodesNumber)];%x,y,z的上限[200,200,50]
fobj = @(x)fun(x,NodesNumber,startPoint,endPoint,ThreatAreaPostion,ThreatAreaRadius);%适应度函数
[Best_pos_ABC,Best_score_ABC,ABC_curve] = ABC(SearchAgents_no,Max_iteration,lb,ub,dim,fobj,22);
execution_times(5) = toc;

% %粒子群优化
tic;
NodesNumber =5;%起点与终点之间节点的个数   %3,6,8，13，14,19
dim = 2*NodesNumber; %维度，一组坐标点为[x,y,z]3个值，,其中X等间隔分布，所以总的数据个数为2*NodesNumber
lb = [20.*ones(1,NodesNumber),0.*ones(1,NodesNumber)];%x,y,z的下限[20,20,0]
ub = [200.*ones(1,NodesNumber),50.*ones(1,NodesNumber)];%x,y,z的上限[200,200,50]
fobj = @(x)fun(x,NodesNumber,startPoint,endPoint,ThreatAreaPostion,ThreatAreaRadius);%适应度函数
[Best_pos_PSO,Best_score_PSO,PSO_curve] = PSO(SearchAgents_no,Max_iteration,lb,ub,dim,fobj,22);
execution_times(6) = toc;
% %沙猫优化
tic;
NodesNumber = 5;%起点与终点之间节点的个数   %3,6,8，13，14,19
dim = 2*NodesNumber; %维度，一组坐标点为[x,y,z]3个值，,其中X等间隔分布，所以总的数据个数为2*NodesNumber
lb = [20.*ones(1,NodesNumber),0.*ones(1,NodesNumber)];%x,y,z的下限[20,20,0]
ub = [200.*ones(1,NodesNumber),50.*ones(1,NodesNumber)];%x,y,z的上限[200,200,50]
fobj = @(x)fun(x,NodesNumber,startPoint,endPoint,ThreatAreaPostion,ThreatAreaRadius);%适应度函数
[Best_pos_SCSO,Best_score_SCSO,SCSO_curve] = SCSO(SearchAgents_no,Max_iteration,lb,ub,dim,fobj,22);
execution_times(7) = toc;
% %遗传算法优化
% [Best_pos_GA,Best_score_GA,GA_curve] = GA(SearchAgents_no,Max_iteration,lb,ub,dim,fobj);
%根据寻优获得的节点，获取插值后的路径
% [X_seq_ISSA,Y_seq_ISSA,Z_seq_ISSA,x_seq_ISSA,y_seq_ISSA,z_seq_ISSA] = GetThePathLine(Best_pos_ISSA,NodesNumber,startPoint,endPoint);
NodesNumber = 6;%起点与终点之间节点的个数   %3,6,8，13，14,19
dim = 2*NodesNumber; %维度，一组坐标点为[x,y,z]3个值，,其中X等间隔分布，所以总的数据个数为2*NodesNumber
lb = [20.*ones(1,NodesNumber),0.*ones(1,NodesNumber)];%x,y,z的下限[20,20,0]
ub = [200.*ones(1,NodesNumber),50.*ones(1,NodesNumber)];%x,y,z的上限[200,200,50]
fobj = @(x)fun(x,NodesNumber,startPoint,endPoint,ThreatAreaPostion,ThreatAreaRadius);%适应度函数
[X_seq_SAA,Y_seq_SAA,Z_seq_SAA,x_seq_SAA,y_seq_SAA,z_seq_SAA] = GetThePathLine(Best_pos_SAA,NodesNumber,startPoint,endPoint);
[X_seq_WOA,Y_seq_WOA,Z_seq_WOA,x_seq_WOA,y_seq_WOA,z_seq_WOA] = GetThePathLine(Best_pos_WOA,NodesNumber,startPoint,endPoint);
[X_seq_GWO,Y_seq_GWO,Z_seq_GWO,x_seq_GWO,y_seq_GWO,z_seq_GWO] = GetThePathLine(Best_pos_GWO,NodesNumber,startPoint,endPoint);
NodesNumber = 2;%起点与终点之间节点的个数   %3,6,8，13，14,19
dim = 2*NodesNumber; %维度，一组坐标点为[x,y,z]3个值，,其中X等间隔分布，所以总的数据个数为2*NodesNumber
lb = [20.*ones(1,NodesNumber),0.*ones(1,NodesNumber)];%x,y,z的下限[20,20,0]
ub = [200.*ones(1,NodesNumber),50.*ones(1,NodesNumber)];%x,y,z的上限[200,200,50]
fobj = @(x)fun(x,NodesNumber,startPoint,endPoint,ThreatAreaPostion,ThreatAreaRadius);%适应度函数
[X_seq_ISAA,Y_seq_ISAA,Z_seq_ISAA,x_seq_ISAA,y_seq_ISAA,z_seq_ISAA] = GetThePathLine(Best_pos_ISAA,NodesNumber,startPoint,endPoint);
NodesNumber = 3;%起点与终点之间节点的个数   %3,6,8，13，14,19
dim = 2*NodesNumber; %维度，一组坐标点为[x,y,z]3个值，,其中X等间隔分布，所以总的数据个数为2*NodesNumber
lb = [20.*ones(1,NodesNumber),0.*ones(1,NodesNumber)];%x,y,z的下限[20,20,0]
ub = [200.*ones(1,NodesNumber),50.*ones(1,NodesNumber)];%x,y,z的上限[200,200,50]
fobj = @(x)fun(x,NodesNumber,startPoint,endPoint,ThreatAreaPostion,ThreatAreaRadius);%适应度函数
[X_seq_ABC,Y_seq_ABC,Z_seq_ABC,x_seq_ABC,y_seq_ABC,z_seq_ABC] = GetThePathLine(Best_pos_ABC,NodesNumber,startPoint,endPoint);
NodesNumber = 5;%起点与终点之间节点的个数   %3,6,8，13，14,19
dim = 2*NodesNumber; %维度，一组坐标点为[x,y,z]3个值，,其中X等间隔分布，所以总的数据个数为2*NodesNumber
lb = [20.*ones(1,NodesNumber),0.*ones(1,NodesNumber)];%x,y,z的下限[20,20,0]
ub = [200.*ones(1,NodesNumber),50.*ones(1,NodesNumber)];%x,y,z的上限[200,200,50]
fobj = @(x)fun(x,NodesNumber,startPoint,endPoint,ThreatAreaPostion,ThreatAreaRadius);%适应度函数
[X_seq_PSO,Y_seq_PSO,Z_seq_PSO,x_seq_PSO,y_seq_PSO,z_seq_PSO] = GetThePathLine(Best_pos_PSO,NodesNumber,startPoint,endPoint);
[X_seq_SCSO,Y_seq_SCSO,Z_seq_SCSO,x_seq_SCSO,y_seq_SCSO,z_seq_SCSO] = GetThePathLine(Best_pos_SCSO,NodesNumber,startPoint,endPoint);


figure(1)
% plot3(X_seq_ISSA,Y_seq_ISSA,Z_seq_ISSA,'r.-','linewidth',3);%绘制ISSA路径
% hold on
set(gcf, 'Color', 'white');  % 将背景设置为白色
p1 = plot3(X_seq_SAA,Y_seq_SAA,Z_seq_SAA,':y','linewidth',2);%绘制SSA路径 黄色
hold on
p2 = plot3(X_seq_WOA,Y_seq_WOA,Z_seq_WOA,'--k','linewidth',2);%绘制WOA路径 黑色
hold on
p3 = plot3(X_seq_GWO,Y_seq_GWO,Z_seq_GWO,'-.g','linewidth',2);%绘制GWO路径 绿色
hold on
p4 = plot3(X_seq_ISAA,Y_seq_ISAA,Z_seq_ISAA,'-.b','linewidth',2);%绘制GWO路径 蓝色
hold on
p5 = plot3(X_seq_ABC,Y_seq_ABC,Z_seq_ABC,'-.m','linewidth',2);%绘制ABC路径 Magenta dash-dot line for ABC
hold on
p6 = plot3(X_seq_PSO,Y_seq_PSO,Z_seq_PSO,'-.r','linewidth',2);%绘制PSO路径 Red dash-dot line for PSO
hold on
p7 = plot3(X_seq_SCSO,Y_seq_SCSO,Z_seq_SCSO,'-.c','linewidth',2);%绘制SCSO路径 Cyan dash-dot line for SCSO


% plot3(x_seq_SAA,y_seq_SAA,z_seq_SAA,'y*');%绘制节点
% hold on
% plot3(x_seq_WOA,y_seq_WOA,z_seq_WOA,'k*');%绘制节点
% hold on
% plot3(x_seq_GWO,y_seq_GWO,z_seq_GWO,'g*');%绘制节点
% hold on
% plot3(x_seq_ISAA,y_seq_ISAA,z_seq_ISAA,'b*');%绘制节点
% hold on
% % plot3(x_seq_ABC,y_seq_ABC,z_seq_ABC,'m*');%绘制节点
% % hold on
% plot3(x_seq_PSO,y_seq_PSO,z_seq_PSO,'r*');%绘制节点
% hold on
% plot3(x_seq_SCSO,y_seq_SCSO,z_seq_SCSO,'m*');%绘制节点
% title('Optimization path(yellow：SAA，red：WOA，green：GWO，blue：SAA)')
% 添加图例并设置颜色
% 添加威胁区域图例

% legend([p1, p2, p3, p4,p5,p6,p7 threat_handles{1}], {'SAA', 'WOA', 'GWO', 'ISAA','ABC','PSO','SCSO', 'Threat Area'}, 'Location', 'northwest');
legend([p1, p2, p3, p4,p5,p6,p7 ], {'SAA', 'WOA', 'GWO', 'MSAA','ABC','PSO','SCSO'}, 'Location', 'northwest');
% title('Optimization path(black：ISSA，yellow：SSA，red：WOA，green：GWO，blue：SAA)')

%% 绘制迭代曲线
figure(2)
set(gcf, 'Color', 'white');  % 将背景设置为白色
% plot(ISSA_curve,'Color','r','linewidth',2);
% hold on
plot(SAA_curve, '-oy', 'linewidth', 1, 'MarkerIndices', 1:10:length(SAA_curve)); % Yellow for SAA, 'o' markers every 10 iterations
hold on;
plot(WOA_curve, '-*k', 'linewidth', 1, 'MarkerIndices', 1:10:length(WOA_curve)); % Black for WOA, '*' markers every 10 iterations
hold on;
plot(GWO_curve, '-sg', 'linewidth', 1, 'MarkerIndices', 1:10:length(GWO_curve)); % Green for GWO, 's' markers every 10 iterations
hold on;
plot(ISAA_curve, '-db', 'linewidth', 1, 'MarkerIndices', 1:10:length(ISAA_curve)); % Blue for MSAA, 'd' markers every 10 iterations
hold on;
plot(ABC_curve, '-pm', 'linewidth', 1, 'MarkerIndices', 1:10:length(ABC_curve)); % Magenta for ABC, 'p' markers every 10 iterations
hold on;
plot(PSO_curve, '-^r', 'linewidth', 1, 'MarkerIndices', 1:10:length(PSO_curve)); % Red for PSO, '^' markers every 10 iterations
hold on;
plot(SCSO_curve, '-hc', 'linewidth', 1, 'MarkerIndices', 1:10:length(SCSO_curve)); % Cyan for SCSO, 'h' markers every 10 iterations
grid on
% legend('ISSA','SSA','WOA','GWO','SAA');
legend('SAA','WOA','GWO','MSAA','ABC','PSO','SCSO');
title('Convergence curve comparison')
xlabel('Number of iteration');
ylabel('Optimal fitness value');
% disp(['ISSA最优适应度值为：',num2str(Best_score_ISSA)]);
disp(['SAA最优适应度值为：',num2str(Best_score_SAA)]);
disp(['WOA最优适应度值为：',num2str(Best_score_WOA)]);
disp(['GWO最优适应度值为：',num2str(Best_score_GWO)]);
disp(['MSAA最优适应度值为：',num2str(Best_score_ISAA)]);
disp(['ABC最优适应度值为：',num2str(Best_score_ABC)]);
disp(['PSO最优适应度值为：',num2str(Best_score_PSO)]);
disp(['SCSO最优适应度值为：',num2str(Best_score_SCSO)]);

%% 生成顶视图
figure(3)
set(gcf, 'Color', 'white');  % 将背景设置为白色
mesh(Map);
hold on;
for i = 1:length(ThreatAreaRadius)
    h = mesh(threat_handles{i}.XData, threat_handles{i}.YData, threat_handles{i}.ZData);
    h.FaceColor = 'blue'; % 设置圆柱体的面颜色为蓝色
    h.EdgeColor = 'none'; % 设置圆柱体的边缘颜色为无
end
plot3(startPoint(1), startPoint(2), startPoint(3), 'ro');
text(startPoint(1), startPoint(2), startPoint(3), 'Starting point')
plot3(endPoint(1), endPoint(2), endPoint(3), 'r*');
text(endPoint(1), endPoint(2), endPoint(3), 'Destination')

p1 = plot3(X_seq_SAA,Y_seq_SAA,Z_seq_SAA,':y','linewidth',2);%绘制SSA路径 黄色
hold on
p2 = plot3(X_seq_WOA,Y_seq_WOA,Z_seq_WOA,'--k','linewidth',2);%绘制WOA路径 黑色
hold on
p3 = plot3(X_seq_GWO,Y_seq_GWO,Z_seq_GWO,'-.g','linewidth',2);%绘制GWO路径 绿色
hold on
p4 = plot3(X_seq_ISAA,Y_seq_ISAA,Z_seq_ISAA,'-.b','linewidth',2);%绘制GWO路径 蓝色
hold on
p5 = plot3(X_seq_ABC,Y_seq_ABC,Z_seq_ABC,'-.m','linewidth',2);%绘制ABC路径 Magenta dash-dot line for ABC
hold on
p6 = plot3(X_seq_PSO,Y_seq_PSO,Z_seq_PSO,'-.r','linewidth',2);%绘制PSO路径 Red dash-dot line for PSO
hold on
p7 = plot3(X_seq_SCSO,Y_seq_SCSO,Z_seq_SCSO,'-.c','linewidth',2);%绘制SCSO路径 Cyan dash-dot line for SCSO

% plot3(x_seq_ISSA,y_seq_ISSA,z_seq_ISSA,'b*');%绘制节点
% hold on
% plot3(x_seq_SAA,y_seq_SAA,z_seq_SAA,'y*');%绘制节点
% hold on
% plot3(x_seq_WOA,y_seq_WOA,z_seq_WOA,'k*');%绘制节点
% hold on
% plot3(x_seq_GWO,y_seq_GWO,z_seq_GWO,'g*');%绘制节点
% hold on
% plot3(x_seq_ISAA,y_seq_ISAA,z_seq_ISAA,'b*');%绘制节点
% hold on
% plot3(x_seq_ABC,y_seq_ABC,z_seq_ABC,'m*');%绘制节点
% hold on
% plot3(x_seq_PSO,y_seq_PSO,z_seq_PSO,'r*');%绘制节点
% hold on
% plot3(x_seq_SCSO,y_seq_SCSO,z_seq_SCSO,'c*');%绘制节点

view(2); % 设置视角为顶视图
% title('Top View of Optimization Paths (yellow: SSA, red: WOA, green: GWO, blue: SAA)')
% legend([p1, p2, p3, p4,p5,p6,p7,threat_handles{1}], {'SAA', 'WOA', 'GWO', 'MSAA','ABC','PSO','SCSO', 'Threat Area'}, 'Location', 'northwest');
legend([p1, p2, p3, p4,p5,p6,p7 ], {'SAA', 'WOA', 'GWO', 'MSAA','ABC','PSO','SCSO'}, 'Location', 'northwest');

%% 创建 Figure 4 并设置正面视角
figure(4);
set(gcf, 'Color', 'white');  % 将背景设置为白色
mesh(Map);
hold on;
for i = 1:length(ThreatAreaRadius)
    [X, Y, Z] = cylinder(ThreatAreaRadius(i), 50);
    X = X + ThreatAreaPostion(i,1);
    Y = Y + ThreatAreaPostion(i,2);
    Z(2,:) = Z(2,:) + 50;
    h = mesh(X, Y, Z);
    h.FaceColor = 'blue';
    h.EdgeColor = 'none';
end
plot3(startPoint(1), startPoint(2), startPoint(3), 'ro');
text(startPoint(1), startPoint(2), startPoint(3), 'Starting point');
plot3(endPoint(1), endPoint(2), endPoint(3), 'r*');
text(endPoint(1), endPoint(2), endPoint(3), 'Destination');

p1 = plot3(X_seq_SAA,Y_seq_SAA,Z_seq_SAA,':y','linewidth',2);%绘制SSA路径 黄色
hold on
p2 = plot3(X_seq_WOA,Y_seq_WOA,Z_seq_WOA,'--k','linewidth',2);%绘制WOA路径 黑色
hold on
p3 = plot3(X_seq_GWO,Y_seq_GWO,Z_seq_GWO,'-.g','linewidth',2);%绘制GWO路径 绿色
hold on
p4 = plot3(X_seq_ISAA,Y_seq_ISAA,Z_seq_ISAA,'-.b','linewidth',2);%绘制GWO路径 蓝色
hold on
p5 = plot3(X_seq_ABC,Y_seq_ABC,Z_seq_ABC,'-.m','linewidth',2);%绘制ABC路径 Magenta dash-dot line for ABC
hold on
p6 = plot3(X_seq_PSO,Y_seq_PSO,Z_seq_PSO,'-.r','linewidth',2);%绘制PSO路径 Red dash-dot line for PSO
hold on
p7 = plot3(X_seq_SCSO,Y_seq_SCSO,Z_seq_SCSO,'-.c','linewidth',2);%绘制SCSO路径 Cyan dash-dot line for SCSO

% plot3(x_seq_ISSA,y_seq_ISSA,z_seq_ISSA,'b*');%绘制节点
% hold on
% plot3(x_seq_SAA,y_seq_SAA,z_seq_SAA,'y*');%绘制节点
% hold on
% plot3(x_seq_WOA,y_seq_WOA,z_seq_WOA,'k*');%绘制节点
% hold on
% plot3(x_seq_GWO,y_seq_GWO,z_seq_GWO,'g*');%绘制节点
% hold on
% plot3(x_seq_ISAA,y_seq_ISAA,z_seq_ISAA,'b*');%绘制节点
% hold on
% plot3(x_seq_ABC,y_seq_ABC,z_seq_ABC,'m*');%绘制节点
% hold on
% plot3(x_seq_PSO,y_seq_PSO,z_seq_PSO,'r*');%绘制节点
% hold on
% plot3(x_seq_SCSO,y_seq_SCSO,z_seq_SCSO,'c*');%绘制节点

% title('Optimization path - Front View (yellow: SAA, red: WOA, green: GWO, blue: SAA)');
view([0, 0]); % 设置正面视角
% legend([p1, p2, p3, p4,p5,p6,p7,threat_handles{1}], {'SAA', 'WOA', 'GWO', 'MSAA','ABC','PSO','SCSO', 'Threat Area'}, 'Location', 'northwest');
legend([p1, p2, p3, p4,p5,p6,p7 ], {'SAA', 'WOA', 'GWO', 'MSAA','ABC','PSO','SCSO'}, 'Location', 'northwest');

%% 绘制柱状图
figure(5);
set(gcf, 'Color', 'white');  % 将背景设置为白色
bar(execution_times);
ylabel('Execution Time (s)');
set(gca, 'XTickLabel', algorithm_names);
title('Execution Time of Different Algorithms');
grid on;

%% 添加Best_score的柱状图，并设置不同颜色
% Define the best scores for each algorithm
Best_scores = [Best_score_SAA, Best_score_WOA, Best_score_GWO, Best_score_ISAA, Best_score_ABC, Best_score_PSO, Best_score_SCSO];

% Define the algorithm names
algorithms = {'SAA', 'WOA', 'GWO', 'MSAA', 'ABC', 'PSO', 'SCSO'};

% Define the colors for each bar in RGB format
colors = [
    1 0 0;   % Red
    1 1 0;   % Yellow
    0 0 0;   % Black
    0 0 1;   % Blue
    0 1 0;   % Green
    0.5 0.5 0.5; % Grey
    0.5 0 0.5;   % Purple
];

% Create the figure
figure(6)
set(gcf, 'Color', 'white');  % Set the background color to white

% Create the bar chart
b = bar(Best_scores, 'FaceColor', 'flat');

% Set the color for each bar
for k = 1:length(Best_scores)
    b.CData(k,:) = colors(k,:);
end

% Set the x-axis labels to the algorithm names
set(gca, 'XTickLabel', algorithms);

% Add labels and title
ylabel('Average cost');
% title('Best Scores of Different Algorithms');

% Enable the grid
grid on;

% 在柱子上添加数值标签
for i = 1:length(Best_scores)
    text(i, Best_scores(i), num2str(Best_scores(i), '%.2f'), ...
        'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', 10);
end
% 
% % Add colored blocks next to x-axis labels
% hold on;
% for i = 1:length(Best_scores)
%     % Draw a rectangle with the same color as the corresponding bar
%     rectangle('Position', [i-0.4, -max(Best_scores)*0.05, 0.8, max(Best_scores)*0.04], 'FaceColor', colors(i,:), 'EdgeColor', 'none');
% end
% hold off;
% 
% % Adjust the plot limits to accommodate the colored blocks
% ylim([-max(Best_scores)*0.1, max(Best_scores) + 10]);



