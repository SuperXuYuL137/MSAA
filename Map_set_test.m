clear all;
close all;
clc;
N = 1; 
dim = 1000;  % 数据维度
label = (1:1:10); % 标签选择
% 初始化一个 cell 数组用于存储不同 label 对应的结果
results_cell = cell(1, length(label));
tle = cell(1, length(label));
%% 混沌直方图
figure;
set(gcf, 'Color', 'white');  % 将背景设置为白色
for i = 1:length(label)
    % 调用 Map 函数生成结果
    [results_cell{i},tle{i}] = Map_set(N, dim, label(i));
    hold on
    subplot(2, 5, i);
    h1=histogram(results_cell{i},10, 'FaceColor', 'blue', 'EdgeColor', 'black');
    xlim([0,1])%设置x轴范围
    title(tle{i})
    hold on
end

%% 混沌图形
figure; % 创建新的图形窗口
set(gcf, 'Color', 'white');  % 将背景设置为白色
for i = 1:length(label)
    % 调用 Map 函数生成结果
    [results_cell{i},tle{i}] = Map_set(N, dim, label(i));
    % 在子图中绘制结果
    subplot(2, 5, i);
    plot(results_cell{i});
    xlabel('Iteration');
    ylabel('Chaos value');
    title(tle{i});
end
%% 混沌点图
figure; % 创建新的图形窗口
set(gcf, 'Color', 'white');  % 将背景设置为白色
for i = 1:length(label)
    % 调用 Map 函数生成结果
    [results_cell{i}, tle{i}] = Map_set(N, dim, label(i));
    
    % 在子图中绘制结果，以点的形式显示
    subplot(2, 5, i);
    scatter(1:numel(results_cell{i}), results_cell{i},3, 'filled');
    xlabel('Iteration');
    ylabel('Chaos value');
    title(tle{i});
end