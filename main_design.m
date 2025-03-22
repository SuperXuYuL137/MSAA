%% 用于计算算法的各个测试数据
% 7中算法的对比实验
clc;clear;close all;warning off
addpath(genpath(pwd));
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


type=3;  % 优化问题代号，1-32，选择对应的数字即可（自行修改）
%% 算法参数设置 Parameters-（自行修改）
nPop=70; % 种群数
Max_iter=80;% 最大迭代次数
%% 使用算法求解
run_times= 5; % 运行次数（自行修改）
Optimal_results={}; % 结果保存在Optimal results
% 第1行：算法名字
% 第2行：收敛曲线
% 第3行：最优函数值
% 第4行：最优解
% 第5行：运行时间
for run_time=1:run_times
%-----------------------------------你的算法放在首位： MSAA----------------------------------
tic
NodesNumber = 6; % 起点与终点之间节点的个数
dim = 2 * NodesNumber; % 维度，一组坐标点为[x, y, z]3个值，其中X等间隔分布，所以总的数据个数为2*NodesNumber
lb = [20.*ones(1, NodesNumber), 0.*ones(1, NodesNumber)]; % x, y, z的下限[20, 20, 0]
ub = [180.*ones(1, NodesNumber), 50.*ones(1, NodesNumber)]; % x, y, z的上限[200, 200, 50]
fobj = @(x)fun(x, NodesNumber, startPoint, endPoint, ThreatAreaPostion, ThreatAreaRadius); % 适应度函数
[Best_x,Best_f,cg_curve]=ISAA(nPop,Max_iter,lb,ub,dim,fobj,4);
Optimal_results{1,1}='MSAA';
Optimal_results{2,1}(run_time,:)=cg_curve;
Optimal_results{3,1}(run_time,:)=Best_f;
Optimal_results{4,1}(run_time,:)=Best_x;
Optimal_results{5,1}(run_time,:)=toc;

%-----------------------------后面的算法为对比的算法---------------------
%----------------------------------- WOA----------------------------------- 
tic
NodesNumber = 6; % 起点与终点之间节点的个数
dim = 2 * NodesNumber; % 维度，一组坐标点为[x, y, z]3个值，其中X等间隔分布，所以总的数据个数为2*NodesNumber
lb = [20.*ones(1, NodesNumber), 0.*ones(1, NodesNumber)]; % x, y, z的下限[20, 20, 0]
ub = [180.*ones(1, NodesNumber), 50.*ones(1, NodesNumber)]; % x, y, z的上限[200, 200, 50]
fobj = @(x)fun(x, NodesNumber, startPoint, endPoint, ThreatAreaPostion, ThreatAreaRadius); % 适应度函数
[Best_x,Best_f,cg_curve]=WOA(nPop,Max_iter,lb,ub,dim,fobj,22);
Optimal_results{1,2}='WOA';
Optimal_results{2,2}(run_time,:)=cg_curve;
Optimal_results{3,2}(run_time,:)=Best_f;
Optimal_results{4,2}(run_time,:)=Best_x;
Optimal_results{5,2}(run_time,:)=toc;

%-----------------------------------  GWO----------------------------------- 
tic
NodesNumber = 6; % 起点与终点之间节点的个数
dim = 2 * NodesNumber; % 维度，一组坐标点为[x, y, z]3个值，其中X等间隔分布，所以总的数据个数为2*NodesNumber
lb = [20.*ones(1, NodesNumber), 0.*ones(1, NodesNumber)]; % x, y, z的下限[20, 20, 0]
ub = [180.*ones(1, NodesNumber), 50.*ones(1, NodesNumber)]; % x, y, z的上限[200, 200, 50]
fobj = @(x)fun(x, NodesNumber, startPoint, endPoint, ThreatAreaPostion, ThreatAreaRadius); % 适应度函数
[Best_x,Best_f,cg_curve]=GWO(nPop,Max_iter,lb,ub,dim,fobj,22);
Optimal_results{1,3}='GWO';
Optimal_results{2,3}(run_time,:)=cg_curve;
Optimal_results{3,3}(run_time,:)=Best_f;
Optimal_results{4,3}(run_time,:)=Best_x;
Optimal_results{5,3}(run_time,:)=toc;

%----------------------------------- PSO----------------------------------- 
tic
NodesNumber = 6; % 起点与终点之间节点的个数
dim = 2 * NodesNumber; % 维度，一组坐标点为[x, y, z]3个值，其中X等间隔分布，所以总的数据个数为2*NodesNumber
lb = [20.*ones(1, NodesNumber), 0.*ones(1, NodesNumber)]; % x, y, z的下限[20, 20, 0]
ub = [180.*ones(1, NodesNumber), 50.*ones(1, NodesNumber)]; % x, y, z的上限[200, 200, 50]
fobj = @(x)fun(x, NodesNumber, startPoint, endPoint, ThreatAreaPostion, ThreatAreaRadius); % 适应度函数
[Best_x,Best_f,cg_curve]=PSO(nPop,Max_iter,lb,ub,dim,fobj,22);
Optimal_results{1,4}='PSO';
Optimal_results{2,4}(run_time,:)=cg_curve;
Optimal_results{3,4}(run_time,:)=Best_f;
Optimal_results{4,4}(run_time,:)=Best_x;
Optimal_results{5,4}(run_time,:)=toc;
% -----------------------------------ABC--------------------------------
tic
NodesNumber = 3; % 起点与终点之间节点的个数
dim = 2 * NodesNumber; % 维度，一组坐标点为[x, y, z]3个值，其中X等间隔分布，所以总的数据个数为2*NodesNumber
lb = [20.*ones(1, NodesNumber), 0.*ones(1, NodesNumber)]; % x, y, z的下限[20, 20, 0]
ub = [180.*ones(1, NodesNumber), 50.*ones(1, NodesNumber)]; % x, y, z的上限[200, 200, 50]
fobj = @(x)fun(x, NodesNumber, startPoint, endPoint, ThreatAreaPostion, ThreatAreaRadius); % 适应度函数
[Best_x,Best_f,cg_curve]=ABC(nPop,Max_iter,lb,ub,dim,fobj,22);
Optimal_results{1,5}='ABC';         % 算法名字
Optimal_results{2,5}(run_time,:)=cg_curve;      % 收敛曲线
Optimal_results{3,5}(run_time,:)=Best_f;          % 最优函数值
Optimal_results{4,5}(run_time,:)=Best_x;          % 最优变量
Optimal_results{5,5}(run_time,:)=toc;             % 运行时间

%----------------------------------- SCSO----------------------------------- 
tic
NodesNumber = 6; % 起点与终点之间节点的个数
dim = 2 * NodesNumber; % 维度，一组坐标点为[x, y, z]3个值，其中X等间隔分布，所以总的数据个数为2*NodesNumber
lb = [20.*ones(1, NodesNumber), 0.*ones(1, NodesNumber)]; % x, y, z的下限[20, 20, 0]
ub = [180.*ones(1, NodesNumber), 50.*ones(1, NodesNumber)]; % x, y, z的上限[200, 200, 50]
fobj = @(x)fun(x, NodesNumber, startPoint, endPoint, ThreatAreaPostion, ThreatAreaRadius); % 适应度函数
[Best_x,Best_f,cg_curve]=SCSO(nPop,Max_iter,lb,ub,dim,fobj,22);
Optimal_results{1,6}='SCSO';
Optimal_results{2,6}(run_time,:)=cg_curve;
Optimal_results{3,6}(run_time,:)=Best_f;
Optimal_results{4,6}(run_time,:)=Best_x;
Optimal_results{5,6}(run_time,:)=toc;
%----------------------------------- SAA----------------------------------- 
tic
NodesNumber = 6; % 起点与终点之间节点的个数
dim = 2 * NodesNumber; % 维度，一组坐标点为[x, y, z]3个值，其中X等间隔分布，所以总的数据个数为2*NodesNumber
lb = [20.*ones(1, NodesNumber), 0.*ones(1, NodesNumber)]; % x, y, z的下限[20, 20, 0]
ub = [180.*ones(1, NodesNumber), 50.*ones(1, NodesNumber)]; % x, y, z的上限[200, 200, 50]
fobj = @(x)fun(x, NodesNumber, startPoint, endPoint, ThreatAreaPostion, ThreatAreaRadius); % 适应度函数
[Best_x,Best_f,cg_curve]=SAA(nPop,Max_iter,lb,ub,dim,fobj,22);
Optimal_results{1,7}='SAA';
Optimal_results{2,7}(run_time,:)=cg_curve;
Optimal_results{3,7}(run_time,:)=Best_f;
Optimal_results{4,7}(run_time,:)=Best_x;
Optimal_results{5,7}(run_time,:)=toc;

end
% 发现上述调用优化算法的 不同和相同之处了吗？
% 只需修改两处：1.算法名字(前提是算法需整理成统一格式)，2，Optimal_results{m,n}中的位置n
rmpath(genpath('optimization'))
%% 计算统计参数
for i = 1:size(Optimal_results, 2)
    if type == 6  % 第6设计问题
        Optimal_results{4, i}= round(Optimal_results{4, i});% 第6设计问题中有的参数是整数，因此采用取整
    elseif type == 9  % 第9设计问题
        Optimal_results{4, i}(1) = round(Optimal_results{4, i}(1) );% 第9设计问题中有的参数是整数，因此采用取整
    elseif type==7 % 第7个问题设计
        Optimal_results{2,i}=-Optimal_results{2, i}; % 第7个设计问题是求最大值，而算法寻优时采用的最小值，因此取负
        Optimal_results{3,i}=-Optimal_results{3, i}; % 第7个设计问题的参数是整数，因此采用取整
        Optimal_results{4, i}(3) = round(Optimal_results{4, i}(3));
    end
end
%     Results的第1行 = 算法名字
%     Results的第2行 =平均收敛曲线
%     Results的第3行 =最差值worst
%     Results的第4行 = 最优值best
%     Results的第5行 =标准差值 std
%     Results的第6行 = 平均值 mean
%     Results的第7行 = 中值   median
[Results,wilcoxon_test,friedman_p_value]=Cal_stats(Optimal_results);

% % 以多次结果的最优值 作为最终结果
% for k=1:size(Optimal_results, 2)
%     [m,n]=min(Optimal_results{3, k}); % 找到 bestf 里的最小值索引： 第m行 第n列
%     opti_para(k,:)=Optimal_results{4, k}(n, :) ; % 利用最小索引值 找到对应的最优解
% end

% %% 保存到excel
% filename = ['工程设计' num2str(type) '.xlsx']; % 保存的文件名字
% sheet = 1; % 保存到第1个sheet
% str1={'name';'ave-cg';'worst';'best';'std';'mean';'median'};
% xlswrite(filename, str1, sheet, 'A1' )
% xlswrite(filename,Results, sheet, 'B1' ) % 统计指标
% % 保存最优解
% sheet = 2 ;% 保存到第2个sheet
% xlswrite(filename, Optimal_results(1,:)', sheet, 'A1' ) % 算法名字
% xlswrite(filename,opti_para, sheet, 'B1' ) % 最优解

%% 保存到mat(若不保存，可以将此部分注释掉)
% 将 结果 保存 mat
save (['工程设计' num2str(type) '.mat'], 'Optimal_results', 'Results','wilcoxon_test','friedman_p_value')

%% 绘图
figure('name','收敛曲线')
for i = 1:size(Optimal_results, 2)
%     plot(mean(Optimal_results{2, i},1),'Linewidth',2)
    semilogy(mean(Optimal_results{2, i},1),'Linewidth',2)
    hold on
end
title(['Convergence curve'])
xlabel('Iteration');ylabel(['Best score']);
grid on; box on
set(gcf,'Position',[400 200 400 250]);
legend(Optimal_results{1, :})
saveas(gcf,['收敛曲线-工程设计' num2str(type)]) % 保存图窗

% 箱线图
boxplot_mat = []; % 矩阵
for i=1:size(Optimal_results,2)
    boxplot_mat = cat(2,boxplot_mat,Optimal_results{3,i}); % Optimal_results第3行保存的是 最优函数值
end
figure('name','箱线图','Position',[400 200 600 200])
boxplot(boxplot_mat)
ylabel('Fitness value');xlabel('Different Algorithms');
set(gca,'XTickLabel',{Optimal_results{1, :}}) % Optimal_results第1行保存的是 算法名字
set(gcf, 'Color', 'white');  % Set the background color to white
saveas(gcf,['箱线图-工程设计' num2str(type)]) % 保存图窗
