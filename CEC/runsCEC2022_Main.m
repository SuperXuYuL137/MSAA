%% 淘个代码 %%
% 2023/10/07 %
%微信公众号搜索：淘个代码，获取更多免费代码
%禁止倒卖转售，违者必究！！！！！
%唯一官方店铺：https://mbd.pub/o/author-amqYmHBs/work，其他途径都是骗子！
%%
%%
clear
clc
close all
addpath(genpath(pwd));
pop_size=30;   %种群数目
max_iter=500;   %迭代次数

run = 30;
box_pp = 1;  %可选1，或者其他。当等于1，绘制箱型图，否则不绘制
RESULT=[];   %统计标准差，平均值，最优值等结果
rank_sum_RESULT=[];  %统计秩和检验结果

F = [1 2 3 4 5 6 7 8 9 10 11 12];
variables_no = 10; % 可选 2, 10, 20
disp(['正在统计的是维度为',num2str(variables_no),'的CEC2022函数集'])
if box_pp ==1
    figure('Name', '箱型图', 'Color', 'w','Position', [50 50 1400 700])
end

for func_num = 1:length(F)   
    % Display the comprehensive results
    disp(['F',num2str(F(func_num)),'函数计算结果：'])
    num=F(func_num);
    [lower_bound,upper_bound,variables_no,fobj]=Get_Functions_cec2022(num,variables_no);  % [lb,ub,D,y]：下界、上界、维度、目标函数表达式
    resu = [];  %统计标准差，平均值，最优值等结果
    rank_sum_resu = [];   %统计秩和检验结果
    box_plot = [];  %统计箱型图结果
    %% Run the HSAA algorithm for "run" times
    for nrun=1:run
        [final,position,iter]=ISAA(pop_size,max_iter,lower_bound,upper_bound,variables_no,fobj);
        final_main(nrun)=final;
        z1(nrun) =  final;
    end
    box_plot = [box_plot;final_main]; %统计箱型图结果
    zz = [min(final_main);std(final_main);mean(final_main);median(final_main);max(final_main)];
    resu = [resu,zz];
    disp(['HSAA：最优值:',num2str(zz(1)),' 标准差:',num2str(zz(2)),' 平均值:',num2str(zz(3)),' 中值:',num2str(zz(4)),' 最差值:',num2str(zz(5))]);
   
    %% Run the WOA algorithm for "run" times
    for nrun=1:run
        [final,position,iter]=WOA(pop_size,max_iter,lower_bound,upper_bound,variables_no,fobj);
        final_main(nrun)=final;
        z2(nrun) =  final;
    end
    box_plot = [box_plot;final_main]; %统计箱型图结果
    zz = [min(final_main);std(final_main);mean(final_main);median(final_main);max(final_main)];
    resu = [resu,zz];
    rs = ranksum(z1,z2);
    if isnan(rs)  %当z1与z2完全一致时会出现NaN值，这种概率很小，但是要做一个防止报错
        rs=1;
    end
    rank_sum_resu = [rank_sum_resu,rs]; %统计秩和检验结果WOA
    disp(['WOA：最优值:',num2str(zz(1)),' 标准差:',num2str(zz(2)),' 平均值:',num2str(zz(3)),' 中值:',num2str(zz(4)),' 最差值:',num2str(zz(5))]);

    %% Run the PSO algorithm for "run" times
    for nrun=1:run
        [final,position,iter]=PSO(pop_size,max_iter,lower_bound,upper_bound,variables_no,fobj);
        final_main(nrun)=final;
        z2(nrun) =  final;
    end
    box_plot = [box_plot;final_main]; %统计箱型图结果
    zz = [min(final_main);std(final_main);mean(final_main);median(final_main);max(final_main)];
    resu = [resu,zz];
    rs = ranksum(z1,z2);
    if isnan(rs)  %当z1与z2完全一致时会出现NaN值，这种概率很小，但是要做一个防止报错
        rs=1;
    end
    rank_sum_resu = [rank_sum_resu,rs]; %统计秩和检验结果PSO
    disp(['PSO：最优值:',num2str(zz(1)),' 标准差:',num2str(zz(2)),' 平均值:',num2str(zz(3)),' 中值:',num2str(zz(4)),' 最差值:',num2str(zz(5))]);

    %% Run the GWO algorithm for "run" times
    for nrun=1:run
        [final,position,iter]=GWO(pop_size,max_iter,lower_bound,upper_bound,variables_no,fobj);
        final_main(nrun)=final;
        z2(nrun) =  final;

    end
    box_plot = [box_plot;final_main]; %统计箱型图结果
     zz = [min(final_main);std(final_main);mean(final_main);median(final_main);max(final_main)];
    resu = [resu,zz];
    rs = ranksum(z1,z2);
    if isnan(rs)  %当z1与z2完全一致时会出现NaN值，这种概率很小，但是要做一个防止报错
        rs=1;
    end
    rank_sum_resu = [rank_sum_resu,rs]; %统计秩和检验结果
    disp(['GWO：最优值:',num2str(zz(1)),' 标准差:',num2str(zz(2)),' 平均值:',num2str(zz(3)),' 中值:',num2str(zz(4)),' 最差值:',num2str(zz(5))]);
    
    %% Run the SAA algorithm for "run" times
    for nrun=1:run
        [final,position,iter]=SSA(pop_size,max_iter,lower_bound,upper_bound,variables_no,fobj);

        final_main(nrun)=final;
        z2(nrun) =  final;

    end
    box_plot = [box_plot;final_main]; %统计箱型图结果
    zz = [min(final_main);std(final_main);mean(final_main);median(final_main);max(final_main)];
    resu = [resu,zz];
    rs = ranksum(z1,z2);
    if isnan(rs)  %当z1与z2完全一致时会出现NaN值，这种概率很小，但是要做一个防止报错
        rs=1;
    end
    rank_sum_resu = [rank_sum_resu,rs]; %统计秩和检验结果
    disp(['SAA：最优值:',num2str(zz(1)),' 标准差:',num2str(zz(2)),' 平均值:',num2str(zz(3)),' 中值:',num2str(zz(4)),' 最差值:',num2str(zz(5))]);

    rank_sum_RESULT = [rank_sum_RESULT;rank_sum_resu];  %统计秩和检验结果
    RESULT = [RESULT;resu];   %统计标准差，平均值，最优值等结果
    
    %% 绘制箱型图
    if box_pp == 1 
        subplot(3,4,func_num)  %4行6列
        mycolor = [0.862745098039216,0.827450980392157,0.117647058823529;...
        0.705882352941177,0.266666666666667,0.423529411764706;...
        0.949019607843137,0.650980392156863,0.121568627450980;...
        0.956862745098039,0.572549019607843,0.474509803921569;...
        0.231372549019608,0.490196078431373,0.717647058823529;...
        0.655541222625894,0.122226545135785,0.325468941131211;...
        0.766665984235466,0.955154623456852,0.755161564478523];  %设置一个颜色库
        %% 开始绘图
        %参数依次为数据矩阵、颜色设置、标记符
        box_figure = boxplot(box_plot','color',[0 0 0],'Symbol','o');
        %设置线宽
        set(box_figure,'Linewidth',1.2);
        boxobj = findobj(gca,'Tag','Box');
        for i = 1:5   %因为总共有5个算法，这里记者根据自身实际情况更改！
            patch(get(boxobj(i),'XData'),get(boxobj(i),'YData'),mycolor(i,:),'FaceAlpha',0.5,...
                'LineWidth',0.7);
        end
        set(gca,'XTickLabel',{'HSAA','WOA','PSO','GWO','SAA'});
        title(['F',num2str(F(func_num))])
        hold on
    end 
end
if box_pp ==1   %保存箱线图
    saveas(gcf,'箱线图.png')
end

if exist('result.xls','file')
    delete('result.xls')
end

if exist('ranksumresult.xls','file')
    delete('ranksumresult.xls')
end

%% 将标准差，平均值，最优值等结果写入elcex中
A = "";
for i = 1:length(F)
    str = string(['F',num2str(F(i))]);
    A(5*(i-1)+1:5*i,1)= [str;str;str;str;str];
    A(5*(i-1)+1:5*i,2)= ["min";"std";"avg";"median";"worse"];
end
A = cellstr (A);
A = [A,num2cell(RESULT)];
title = {" "," ","HSAA","WOA","PSO","GWO","SAA"};
A = [title;A];
xlswrite('result.xls', A)


%% 将秩和检验结果写入elcex中
B = string();
for i = 1:length(F)
    str = string(['F',num2str(F(i))]);
    B(i,1)= str;
end
B = cellstr (B);
B = [B,num2cell(rank_sum_RESULT)];
title = {" ","WOA","PSO","GWO","SSA"};%  秩和检验是和改进的算法做比较
B = [title;B];
xlswrite('ranksumresult.xls', B)

rmpath(genpath(pwd))

