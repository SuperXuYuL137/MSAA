%��ά���˻������Ż�

%% ���ݽڵ㣬��������������ֵ��ƽ��·����������·������
%[X_seq,Y_seq,Z_seq]Ϊ��ֵ���·��
%[x_seq,y_seq,z_seq]Ϊ��ֵǰ��·��
function [X_seq,Y_seq,Z_seq,x_seq,y_seq,z_seq] = GetThePathLine(postion,NodesNumber,startPoint,endPoint)
        
        for i = 1:NodesNumber
            postionP(i,1) = startPoint(1) + (endPoint(1)-startPoint(1))*i/(NodesNumber+1);
        end
        postionP(:,2) = postion(1:NodesNumber)';
        postionP(:,3) = postion(NodesNumber + 1:2*NodesNumber)';
        %����X��������
        [~,SortIndex]=sort(postionP(:,1));
        postionP(:,1) = postionP(SortIndex,1);
        postionP(:,2) = postionP(SortIndex,2);
        postionP(:,3) = postionP(SortIndex,3);
         % %��Z����������ʹ�����ɵ�zһ�����ڵ������ɽ�����ϡ�
        for i = 1:size(postionP)
            x= postionP(i,2);
            y = postionP(i,1);
            postionP(i,3) = postionP(i,3) + MapValueFunction(x,y);
        end
        
        
        PALL = [startPoint;postionP;endPoint];%������ʼ��
        x_seq=PALL(:,1);%���нڵ�ĺ�����
        y_seq=PALL(:,2);
        z_seq=PALL(:,3);


        k = size(PALL,1);%���+�յ�+�м�ڵ�
        i_seq = linspace(0,1,k);%���ڲ���x1,x2֮���N����ʸ��������x1��x2��k�ֱ�Ϊ��ʼֵ����ֵֹ��Ԫ�ظ�������ȱʡN��Ĭ�ϵ���Ϊ100����matlab�������������help linspace����doc linspace���Ի�øú����İ�����Ϣ��
        I_seq = linspace(0,1,200);
        %����������ֵ
        X_seq = spline(i_seq,x_seq,I_seq);
        Y_seq = spline(i_seq,y_seq,I_seq);
        Z_seq = spline(i_seq,z_seq,I_seq);
%         X_seq = interp1(i_seq,x_seq,I_seq);
%         Y_seq = interp1(i_seq,y_seq,I_seq);
%         Z_seq = interp1(i_seq,z_seq,I_seq);

end