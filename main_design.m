%% ���ڼ����㷨�ĸ�����������
% 7���㷨�ĶԱ�ʵ��
clc;clear;close all;warning off
addpath(genpath(pwd));
%% ������ͼ
% ��ͼ�Ĵ�С200*200
MapSizeX = 200;
MapSizeY = 200;
sums=0;
avgs=0;
Function_name='UAV';
%% ���ε�ͼ����, ��ͼ��ϸ��������ȥMapValueFunction.m��������
x = 1:1:MapSizeX;
y = 1:1:MapSizeY;
Map = zeros(MapSizeX, MapSizeY); % Ԥ�����ͼ����
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

%% ��в�������
% ��в������������
ThreatAreaPostion = [140, 50];
% ��в����뾶
ThreatAreaRadius = [25];

% ����в������ӵ�ͼ��
figure
set(gcf, 'Color', 'white');  % ����������Ϊ��ɫ
mesh(Map);
hold on;
threat_handles = cell(1, length(ThreatAreaRadius)); % ʹ�õ�Ԫ����洢���
for i = 1:length(ThreatAreaRadius)
    [X, Y, Z] = cylinder(ThreatAreaRadius(i), 50);
    X = X + ThreatAreaPostion(i, 1);
    Y = Y + ThreatAreaPostion(i, 2);
    Z(2,:) = Z(2,:) + 50; % ��в����߶�
    h = mesh(X, Y, Z);
    h.FaceColor = 'blue'; % ����Բ���������ɫΪ��ɫ
    h.EdgeColor = 'none'; % ����Բ����ı�Ե��ɫΪ��
    threat_handles{i} = h; % ������
end

%% ������ʼ��
startPoint = [0, 0, 20];
endPoint = [200, 200, 20];
plot3(startPoint(1), startPoint(2), startPoint(3), 'ro');
text(startPoint(1), startPoint(2), startPoint(3), 'Starting point')
plot3(endPoint(1), endPoint(2), endPoint(3), 'r*');
text(endPoint(1), endPoint(2), endPoint(3), 'Destination')
title('Map information')


type=3;  % �Ż�������ţ�1-32��ѡ���Ӧ�����ּ��ɣ������޸ģ�
%% �㷨�������� Parameters-�������޸ģ�
nPop=70; % ��Ⱥ��
Max_iter=80;% ����������
%% ʹ���㷨���
run_times= 5; % ���д����������޸ģ�
Optimal_results={}; % ���������Optimal results
% ��1�У��㷨����
% ��2�У���������
% ��3�У����ź���ֵ
% ��4�У����Ž�
% ��5�У�����ʱ��
for run_time=1:run_times
%-----------------------------------����㷨������λ�� MSAA----------------------------------
tic
NodesNumber = 6; % ������յ�֮��ڵ�ĸ���
dim = 2 * NodesNumber; % ά�ȣ�һ�������Ϊ[x, y, z]3��ֵ������X�ȼ���ֲ��������ܵ����ݸ���Ϊ2*NodesNumber
lb = [20.*ones(1, NodesNumber), 0.*ones(1, NodesNumber)]; % x, y, z������[20, 20, 0]
ub = [180.*ones(1, NodesNumber), 50.*ones(1, NodesNumber)]; % x, y, z������[200, 200, 50]
fobj = @(x)fun(x, NodesNumber, startPoint, endPoint, ThreatAreaPostion, ThreatAreaRadius); % ��Ӧ�Ⱥ���
[Best_x,Best_f,cg_curve]=ISAA(nPop,Max_iter,lb,ub,dim,fobj,4);
Optimal_results{1,1}='MSAA';
Optimal_results{2,1}(run_time,:)=cg_curve;
Optimal_results{3,1}(run_time,:)=Best_f;
Optimal_results{4,1}(run_time,:)=Best_x;
Optimal_results{5,1}(run_time,:)=toc;

%-----------------------------������㷨Ϊ�Աȵ��㷨---------------------
%----------------------------------- WOA----------------------------------- 
tic
NodesNumber = 6; % ������յ�֮��ڵ�ĸ���
dim = 2 * NodesNumber; % ά�ȣ�һ�������Ϊ[x, y, z]3��ֵ������X�ȼ���ֲ��������ܵ����ݸ���Ϊ2*NodesNumber
lb = [20.*ones(1, NodesNumber), 0.*ones(1, NodesNumber)]; % x, y, z������[20, 20, 0]
ub = [180.*ones(1, NodesNumber), 50.*ones(1, NodesNumber)]; % x, y, z������[200, 200, 50]
fobj = @(x)fun(x, NodesNumber, startPoint, endPoint, ThreatAreaPostion, ThreatAreaRadius); % ��Ӧ�Ⱥ���
[Best_x,Best_f,cg_curve]=WOA(nPop,Max_iter,lb,ub,dim,fobj,22);
Optimal_results{1,2}='WOA';
Optimal_results{2,2}(run_time,:)=cg_curve;
Optimal_results{3,2}(run_time,:)=Best_f;
Optimal_results{4,2}(run_time,:)=Best_x;
Optimal_results{5,2}(run_time,:)=toc;

%-----------------------------------  GWO----------------------------------- 
tic
NodesNumber = 6; % ������յ�֮��ڵ�ĸ���
dim = 2 * NodesNumber; % ά�ȣ�һ�������Ϊ[x, y, z]3��ֵ������X�ȼ���ֲ��������ܵ����ݸ���Ϊ2*NodesNumber
lb = [20.*ones(1, NodesNumber), 0.*ones(1, NodesNumber)]; % x, y, z������[20, 20, 0]
ub = [180.*ones(1, NodesNumber), 50.*ones(1, NodesNumber)]; % x, y, z������[200, 200, 50]
fobj = @(x)fun(x, NodesNumber, startPoint, endPoint, ThreatAreaPostion, ThreatAreaRadius); % ��Ӧ�Ⱥ���
[Best_x,Best_f,cg_curve]=GWO(nPop,Max_iter,lb,ub,dim,fobj,22);
Optimal_results{1,3}='GWO';
Optimal_results{2,3}(run_time,:)=cg_curve;
Optimal_results{3,3}(run_time,:)=Best_f;
Optimal_results{4,3}(run_time,:)=Best_x;
Optimal_results{5,3}(run_time,:)=toc;

%----------------------------------- PSO----------------------------------- 
tic
NodesNumber = 6; % ������յ�֮��ڵ�ĸ���
dim = 2 * NodesNumber; % ά�ȣ�һ�������Ϊ[x, y, z]3��ֵ������X�ȼ���ֲ��������ܵ����ݸ���Ϊ2*NodesNumber
lb = [20.*ones(1, NodesNumber), 0.*ones(1, NodesNumber)]; % x, y, z������[20, 20, 0]
ub = [180.*ones(1, NodesNumber), 50.*ones(1, NodesNumber)]; % x, y, z������[200, 200, 50]
fobj = @(x)fun(x, NodesNumber, startPoint, endPoint, ThreatAreaPostion, ThreatAreaRadius); % ��Ӧ�Ⱥ���
[Best_x,Best_f,cg_curve]=PSO(nPop,Max_iter,lb,ub,dim,fobj,22);
Optimal_results{1,4}='PSO';
Optimal_results{2,4}(run_time,:)=cg_curve;
Optimal_results{3,4}(run_time,:)=Best_f;
Optimal_results{4,4}(run_time,:)=Best_x;
Optimal_results{5,4}(run_time,:)=toc;
% -----------------------------------ABC--------------------------------
tic
NodesNumber = 3; % ������յ�֮��ڵ�ĸ���
dim = 2 * NodesNumber; % ά�ȣ�һ�������Ϊ[x, y, z]3��ֵ������X�ȼ���ֲ��������ܵ����ݸ���Ϊ2*NodesNumber
lb = [20.*ones(1, NodesNumber), 0.*ones(1, NodesNumber)]; % x, y, z������[20, 20, 0]
ub = [180.*ones(1, NodesNumber), 50.*ones(1, NodesNumber)]; % x, y, z������[200, 200, 50]
fobj = @(x)fun(x, NodesNumber, startPoint, endPoint, ThreatAreaPostion, ThreatAreaRadius); % ��Ӧ�Ⱥ���
[Best_x,Best_f,cg_curve]=ABC(nPop,Max_iter,lb,ub,dim,fobj,22);
Optimal_results{1,5}='ABC';         % �㷨����
Optimal_results{2,5}(run_time,:)=cg_curve;      % ��������
Optimal_results{3,5}(run_time,:)=Best_f;          % ���ź���ֵ
Optimal_results{4,5}(run_time,:)=Best_x;          % ���ű���
Optimal_results{5,5}(run_time,:)=toc;             % ����ʱ��

%----------------------------------- SCSO----------------------------------- 
tic
NodesNumber = 6; % ������յ�֮��ڵ�ĸ���
dim = 2 * NodesNumber; % ά�ȣ�һ�������Ϊ[x, y, z]3��ֵ������X�ȼ���ֲ��������ܵ����ݸ���Ϊ2*NodesNumber
lb = [20.*ones(1, NodesNumber), 0.*ones(1, NodesNumber)]; % x, y, z������[20, 20, 0]
ub = [180.*ones(1, NodesNumber), 50.*ones(1, NodesNumber)]; % x, y, z������[200, 200, 50]
fobj = @(x)fun(x, NodesNumber, startPoint, endPoint, ThreatAreaPostion, ThreatAreaRadius); % ��Ӧ�Ⱥ���
[Best_x,Best_f,cg_curve]=SCSO(nPop,Max_iter,lb,ub,dim,fobj,22);
Optimal_results{1,6}='SCSO';
Optimal_results{2,6}(run_time,:)=cg_curve;
Optimal_results{3,6}(run_time,:)=Best_f;
Optimal_results{4,6}(run_time,:)=Best_x;
Optimal_results{5,6}(run_time,:)=toc;
%----------------------------------- SAA----------------------------------- 
tic
NodesNumber = 6; % ������յ�֮��ڵ�ĸ���
dim = 2 * NodesNumber; % ά�ȣ�һ�������Ϊ[x, y, z]3��ֵ������X�ȼ���ֲ��������ܵ����ݸ���Ϊ2*NodesNumber
lb = [20.*ones(1, NodesNumber), 0.*ones(1, NodesNumber)]; % x, y, z������[20, 20, 0]
ub = [180.*ones(1, NodesNumber), 50.*ones(1, NodesNumber)]; % x, y, z������[200, 200, 50]
fobj = @(x)fun(x, NodesNumber, startPoint, endPoint, ThreatAreaPostion, ThreatAreaRadius); % ��Ӧ�Ⱥ���
[Best_x,Best_f,cg_curve]=SAA(nPop,Max_iter,lb,ub,dim,fobj,22);
Optimal_results{1,7}='SAA';
Optimal_results{2,7}(run_time,:)=cg_curve;
Optimal_results{3,7}(run_time,:)=Best_f;
Optimal_results{4,7}(run_time,:)=Best_x;
Optimal_results{5,7}(run_time,:)=toc;

end
% �������������Ż��㷨�� ��ͬ����֮ͬ������
% ֻ���޸�������1.�㷨����(ǰ�����㷨�������ͳһ��ʽ)��2��Optimal_results{m,n}�е�λ��n
rmpath(genpath('optimization'))
%% ����ͳ�Ʋ���
for i = 1:size(Optimal_results, 2)
    if type == 6  % ��6�������
        Optimal_results{4, i}= round(Optimal_results{4, i});% ��6����������еĲ�������������˲���ȡ��
    elseif type == 9  % ��9�������
        Optimal_results{4, i}(1) = round(Optimal_results{4, i}(1) );% ��9����������еĲ�������������˲���ȡ��
    elseif type==7 % ��7���������
        Optimal_results{2,i}=-Optimal_results{2, i}; % ��7����������������ֵ�����㷨Ѱ��ʱ���õ���Сֵ�����ȡ��
        Optimal_results{3,i}=-Optimal_results{3, i}; % ��7���������Ĳ�������������˲���ȡ��
        Optimal_results{4, i}(3) = round(Optimal_results{4, i}(3));
    end
end
%     Results�ĵ�1�� = �㷨����
%     Results�ĵ�2�� =ƽ����������
%     Results�ĵ�3�� =���ֵworst
%     Results�ĵ�4�� = ����ֵbest
%     Results�ĵ�5�� =��׼��ֵ std
%     Results�ĵ�6�� = ƽ��ֵ mean
%     Results�ĵ�7�� = ��ֵ   median
[Results,wilcoxon_test,friedman_p_value]=Cal_stats(Optimal_results);

% % �Զ�ν��������ֵ ��Ϊ���ս��
% for k=1:size(Optimal_results, 2)
%     [m,n]=min(Optimal_results{3, k}); % �ҵ� bestf �����Сֵ������ ��m�� ��n��
%     opti_para(k,:)=Optimal_results{4, k}(n, :) ; % ������С����ֵ �ҵ���Ӧ�����Ž�
% end

% %% ���浽excel
% filename = ['�������' num2str(type) '.xlsx']; % ������ļ�����
% sheet = 1; % ���浽��1��sheet
% str1={'name';'ave-cg';'worst';'best';'std';'mean';'median'};
% xlswrite(filename, str1, sheet, 'A1' )
% xlswrite(filename,Results, sheet, 'B1' ) % ͳ��ָ��
% % �������Ž�
% sheet = 2 ;% ���浽��2��sheet
% xlswrite(filename, Optimal_results(1,:)', sheet, 'A1' ) % �㷨����
% xlswrite(filename,opti_para, sheet, 'B1' ) % ���Ž�

%% ���浽mat(�������棬���Խ��˲���ע�͵�)
% �� ��� ���� mat
save (['�������' num2str(type) '.mat'], 'Optimal_results', 'Results','wilcoxon_test','friedman_p_value')

%% ��ͼ
figure('name','��������')
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
saveas(gcf,['��������-�������' num2str(type)]) % ����ͼ��

% ����ͼ
boxplot_mat = []; % ����
for i=1:size(Optimal_results,2)
    boxplot_mat = cat(2,boxplot_mat,Optimal_results{3,i}); % Optimal_results��3�б������ ���ź���ֵ
end
figure('name','����ͼ','Position',[400 200 600 200])
boxplot(boxplot_mat)
ylabel('Fitness value');xlabel('Different Algorithms');
set(gca,'XTickLabel',{Optimal_results{1, :}}) % Optimal_results��1�б������ �㷨����
set(gcf, 'Color', 'white');  % Set the background color to white
saveas(gcf,['����ͼ-�������' num2str(type)]) % ����ͼ��
