%��ά���˻������Ż�

%% ������Ч·��
function Positions=initialization(SearchAgents_no,dim,ub,lb,label)
global NodesNumber;
global startPoint;
global endPoint;
global ThreatAreaPostion;
global ThreatAreaRadius;
Positions = CreateValidPath(SearchAgents_no,dim,lb,ub,NodesNumber,startPoint,endPoint,ThreatAreaPostion,ThreatAreaRadius,label);

end