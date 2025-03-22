

%% 各函数的最优值 标准差 平均值 中值 最差值 以及wilcoxon秩和检验
clear
clc
close all
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

%% 算法参数设置
NodesNumber = 2; % 起点与终点之间节点的个数
dim = 2 * NodesNumber; % 维度，一组坐标点为[x, y, z]3个值，其中X等间隔分布，所以总的数据个数为2*NodesNumber
lb = [20.*ones(1, NodesNumber), 0.*ones(1, NodesNumber)]; % x, y, z的下限[20, 20, 0]
ub = [180.*ones(1, NodesNumber), 50.*ones(1, NodesNumber)]; % x, y, z的上限[200, 200, 50]
fobj = @(x)fun(x, NodesNumber, startPoint, endPoint, ThreatAreaPostion, ThreatAreaRadius); % 适应度函数
SearchAgents_no = 70; % 种群数量
Max_iteration = 80; % 设定最大迭代次数
number=1; %选定优化函数，自行替换:F1~F10
lower_bound=lb;upper_bound=ub;variables_no=dim;fobj;
pop_size=SearchAgents_no;                      % population members 
max_iter=Max_iteration;                  % maximum number of iteration


run = 5;
box_pp = 1;  %可选1，或者其他。当等于1，绘制箱型图，否则不绘制
RESULT = [];   %统计标准差，平均值，最优值等结果
rank_sum_RESULT = [];  %统计秩和检验结果

F = [1];

disp(['正在统计的是UAV函数适应度值集'])
if box_pp == 1
    figure('Name', '箱型图', 'Color', 'w', 'Position', [50 50 1400 700])
end

for func_num = 1:length(F)   
    % Display the comprehensive results
    disp(['F', num2str(F(func_num)), '函数计算结果：'])
    num = F(func_num);
    
    resu = [];  %统计标准差，平均值，最优值等结果
    rank_sum_resu = [];   %统计秩和检验结果
    box_plot = [];  %统计箱型图结果
    
    %% Run the SCSO algorithm for "run" times
    for nrun = 1:run
        [position, final, iter] = SCSO(pop_size, max_iter, lower_bound, upper_bound, variables_no, fobj,22);
        % final_main(nrun) = final;
        % z1(nrun) = final;
        if isscalar(final)
            final_main(nrun) = final;
        else
            error('Expected scalar value for final in SCSO, got %s.', class(final));
        end
        z1(nrun) = final;
    end
    box_plot = [box_plot; final_main]; %统计箱型图结果
    zz = [min(final_main); std(final_main); mean(final_main); median(final_main); max(final_main)];
    resu = [resu, zz];
    disp(['SCSO：最优值:', num2str(zz(1)), ' 标准差:', num2str(zz(2)), ' 平均值:', num2str(zz(3)), ' 中值:', num2str(zz(4)), ' 最差值:', num2str(zz(5))]);
    
    %% Run the WOA algorithm for "run" times
    for nrun = 1:run
        [position, final, iter] = WOA(pop_size, max_iter, lower_bound, upper_bound, variables_no, fobj,22);
        % final_main(nrun) = final;
        % z2(nrun) = final;
        if isscalar(final)
            final_main(nrun) = final;
        else
            error('Expected scalar value for final in WOA, got %s.', class(final));
        end
        z2(nrun) = final;
    end
    box_plot = [box_plot; final_main]; %统计箱型图结果
    zz = [min(final_main); std(final_main); mean(final_main); median(final_main); max(final_main)];
    resu = [resu, zz];
    rs = ranksum(z1, z2);
    if isnan(rs)  %当z1与z2完全一致时会出现NaN值，这种概率很小，但是要做一个防止报错
        rs = 1;
    end
    rank_sum_resu = [rank_sum_resu, rs]; %统计秩和检验结果
    disp(['WOA：最优值:', num2str(zz(1)), ' 标准差:', num2str(zz(2)), ' 平均值:', num2str(zz(3)), ' 中值:', num2str(zz(4)), ' 最差值:', num2str(zz(5))]);

    %% Run the PSO algorithm for "run" times
    for nrun = 1:run
        [position, final, iter] = PSO(pop_size, max_iter, lower_bound, upper_bound, variables_no, fobj,22);
        % final_main(nrun) = final;
        % z2(nrun) = final;
        if isscalar(final)
            final_main(nrun) = final;
        else
            error('Expected scalar value for final in PSO, got %s.', class(final));
        end
        z2(nrun) = final;
    end
    box_plot = [box_plot; final_main]; %统计箱型图结果
    zz = [min(final_main); std(final_main); mean(final_main); median(final_main); max(final_main)];
    resu = [resu, zz];
    rs = ranksum(z1, z2);
    if isnan(rs)  %当z1与z2完全一致时会出现NaN值，这种概率很小，但是要做一个防止报错
        rs = 1;
    end
    rank_sum_resu = [rank_sum_resu, rs]; %统计秩和检验结果PSO
    disp(['PSO：最优值:', num2str(zz(1)), ' 标准差:', num2str(zz(2)), ' 平均值:', num2str(zz(3)), ' 中值:', num2str(zz(4)), ' 最差值:', num2str(zz(5))]);

    %% Run the GWO algorithm for "run" times
    for nrun = 1:run
        [position, final, iter] = GWO(pop_size, max_iter, lower_bound, upper_bound, variables_no, fobj,22);
        % final_main(nrun) = final;
        % z2(nrun) = final;
        if isscalar(final)
            final_main(nrun) = final;
        else
            error('Expected scalar value for final in GWO, got %s.', class(final));
        end
        z2(nrun) = final;
    end
    box_plot = [box_plot; final_main]; %统计箱型图结果
    zz = [min(final_main); std(final_main); mean(final_main); median(final_main); max(final_main)];
    resu = [resu, zz];
    rs = ranksum(z1, z2);
    if isnan(rs)  %当z1与z2完全一致时会出现NaN值，这种概率很小，但是要做一个防止报错
        rs = 1;
    end
    rank_sum_resu = [rank_sum_resu, rs]; %统计秩和检验结果
    disp(['GWO：最优值:', num2str(zz(1)), ' 标准差:', num2str(zz(2)), ' 平均值:', num2str(zz(3)), ' 中值:', num2str(zz(4)), ' 最差值:', num2str(zz(5))]);
    
    
    %% Run the SAA algorithm for "run" times
    for nrun = 1:run
        [position,final, iter] = SAA(pop_size, max_iter, lower_bound, upper_bound, variables_no, fobj,22);
        % final_main(nrun) = final;
        % z2(nrun) = final;
        if isscalar(final)
            final_main(nrun) = final;
        else
            error('Expected scalar value for final in SAA, got %s.', class(final));
        end
        z2(nrun) = final;
    end
    box_plot = [box_plot; final_main]; %统计箱型图结果
    zz = [min(final_main); std(final_main); mean(final_main); median(final_main); max(final_main)];
    resu = [resu, zz];
    rs = ranksum(z1, z2);
    if isnan(rs)  %当z1与z2完全一致时会出现NaN值，这种概率很小，但是要做一个防止报错
        rs = 1;
    end
    rank_sum_resu = [rank_sum_resu, rs]; %统计秩和检验结果
    disp(['SAA：最优值:', num2str(zz(1)), ' 标准差:', num2str(zz(2)), ' 平均值:', num2str(zz(3)), ' 中值:', num2str(zz(4)), ' 最差值:', num2str(zz(5))]);
    
    %% Run the MSAA algorithm for "run" times
    for nrun = 1:run
        [position, final, iter] = MSAA(pop_size, max_iter, lower_bound, upper_bound, variables_no, fobj,22);

        % final_main(nrun) = final;
        % z2(nrun) = final;
        if isscalar(final)
            final_main(nrun) = final;
        else
            error('Expected scalar value for final in MSAA, got %s.', class(final));
        end
        z2(nrun) = final;
    end
    box_plot = [box_plot; final_main]; %统计箱型图结果
    zz = [min(final_main); std(final_main); mean(final_main); median(final_main); max(final_main)];
    resu = [resu, zz];
    rs = ranksum(z1, z2);
    if isnan(rs)  %当z1与z2完全一致时会出现NaN值，这种概率很小，但是要做一个防止报错
        rs = 1;
    end
    rank_sum_resu = [rank_sum_resu, rs]; %统计秩和检验结果
    disp(['MSAA：最优值:', num2str(zz(1)), ' 标准差:', num2str(zz(2)), ' 平均值:', num2str(zz(3)), ' 中值:', num2str(zz(4)), ' 最差值:', num2str(zz(5))]);

    rank_sum_RESULT = [rank_sum_RESULT; rank_sum_resu];  %统计秩和检验结果
    RESULT = [RESULT; resu];   %统计标准差，平均值，最优值等结果
    
    %% 绘制箱型图
    if box_pp == 1 
        % subplot(4, 6, func_num)  %4行6列
        subplot(1, 1, func_num)  %4行6列
        mycolor = [0.862745098039216, 0.827450980392157, 0.117647058823529;...
        0.705882352941177, 0.266666666666667, 0.423529411764706;...
        0.949019607843137, 0.650980392156863, 0.121568627450980;...
        0.956862745098039, 0.572549019607843, 0.474509803921569;...
        0.231372549019608, 0.490196078431373, 0.717647058823529;...
        0.655541222625894, 0.122226545135785, 0.325468941131211;...
        0.766665984235466, 0.955154623456852, 0.755161564478523];  %设置一个颜色库
        %% 开始绘图
        %参数依次为数据矩阵、颜色设置、标记符
        box_figure = boxplot(box_plot', 'color', [0 0 0], 'Symbol', 'o');
        %设置线宽
        set(box_figure, 'Linewidth', 1.2);
        boxobj = findobj(gca, 'Tag', 'Box');
        for i = 1:6   %因为总共有7个算法，这里根据自身实际情况更改！
            patch(get(boxobj(i), 'XData'), get(boxobj(i), 'YData'), mycolor(i, :), 'FaceAlpha', 0.5,...
                'LineWidth', 0.7);
        end
        set(gca, 'XTickLabel', {'SCSO', 'WOA', 'PSO', 'GWO',  'SAA', 'MSAA'});
        title(['F', num2str(F(func_num))])
        hold on
    end 
end
if box_pp == 1   %保存箱线图
    saveas(gcf, '箱线图.png')
end

if exist('result.xls', 'file')
    delete('result.xls')
end

if exist('ranksumresult.xls', 'file')
    delete('ranksumresult.xls')
end

%% 将标准差，平均值，最优值等结果写入elcex中
A = strings(5 * length(F), 2 + size(RESULT, 2));
for i = 1:length(F)
    str = string(['F', num2str(F(i))]);
    A(5 * (i - 1) + 1:5 * i, 1) = [str; str; str; str; str];
    A(5 * (i - 1) + 1:5 * i, 2) = ["min"; "std"; "avg"; "median"; "worse"];
end
A(:, 3:end) = num2cell(RESULT);
% A = [A, num2cell(RESULT)];
% title = {"SCSO", "WOA", "PSO", "GWO", "SAA", "MSAA"};
% 定义算法的标题行
title = ["Function", "Statistic", "SCSO", "WOA", "PSO", "GWO", "SAA", "MSAA"];

% Concatenate title and A
if size(A, 2) ~= length(title)
    error('Dimension mismatch: The number of columns in A does not match the length of the title row.');
end

A = [title; A];
xlswrite('result.xls', A)

%% 将秩和检验结果写入elcex中
% B = string();

B = strings(length(F), 1 + size(rank_sum_RESULT, 2));

% for i = 1:length(F)
%     str = string(['F', num2str(F(i))]);
%     B(i, 1) = str;
% end
% B = cellstr(B);
% B = [B, num2cell(rank_sum_RESULT)];

% Construct the rank sum result array B
B = strings(length(F), 1 + size(rank_sum_RESULT, 2));
for i = 1:length(F)
    B(i, 1) = ['F', num2str(F(i))];
end
B(:, 2:end) = num2cell(rank_sum_RESULT);

% rank_sum_title = {"SCSO ","WOA", "PSO", "GWO", "SAA", "MSAA"}; % 秩和检验是和改进的算法做比较
rank_sum_title = ["Function", "WOA", "PSO", "GWO", "SAA", "MSAA"]; % 秩和检验是和改进的算法做比较

% Concatenate rank_sum_title and B
if size(B, 2) ~= length(rank_sum_title)
    error('Dimension mismatch: The number of columns in B does not match the length of the rank sum title row.');
end

% B = [title; B];
% xlswrite('ranksumresult.xls', B)
B = [rank_sum_title; B];
xlswrite('ranksumresult.xls', B);

rmpath(genpath(pwd))
