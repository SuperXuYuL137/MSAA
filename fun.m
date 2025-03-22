%��ά���˻������Ż�

%��Ӧ�Ⱥ���
function [fitness,SuccessFlag] = fun(position,NodesNumber,startPoint,endPoint,ThreatAreaPostion,ThreatAreaRadius)

%�ж�·���Ƿ�OK
[SuccessFlag]=IsPathOk(position,NodesNumber,startPoint,endPoint,ThreatAreaPostion,ThreatAreaRadius);
if SuccessFlag<1 %���·����OK�����óͷ�ֵ
    fitness = 10E32;
else
    %��ȡ��ֵ���·��
    [X_seq,Y_seq,Z_seq,x_seq,y_seq,z_seq] = GetThePathLine(position,NodesNumber,startPoint,endPoint); 
    %% �������������õ�����ɢ���·�����ȣ���Ӧ�ȣ�
    dx = diff(X_seq);
    dy = diff(Y_seq);
    dz = diff(Z_seq);

    PathLength = sum(sqrt(dx.^2 + dy.^2 + dz.^2));%·������

    Height = sum(((Z_seq - mean(Z_seq)).^2).^0.5); %�߶�����

    Dx = diff(x_seq');
    Dy = diff(y_seq');
    Dz = diff(z_seq');

    for i = 1:size(Dx,2)-1
       C(i) = (Dx(i)*Dx(i+1)+Dy(i)*Dy(i+1)+Dz(i)*Dz(i+1))/(sqrt(Dx(i)^2+Dy(i)^2+Dz(i)^2)*sqrt(Dx(i+1)^2+Dy(i+1)^2+Dz(i+1)^2)) ;
    end

    phi = pi/2;
    Curve = sum(cos(phi)-C);  %ת�������
    %����Ȩ��
    w1 = 0.4;
    w2 = 0.4;
    w3 = 0.2;
    fitness = w1*PathLength+w2*Height + w3*Curve;
    
end

end