%三维无人机航迹优化

%% 创建有效路径
function Positions=initialization(SearchAgents_no,dim,ub,lb,label)
global NodesNumber;
global startPoint;
global endPoint;
global ThreatAreaPostion;
global ThreatAreaRadius;
Positions = CreateValidPath(SearchAgents_no,dim,lb,ub,NodesNumber,startPoint,endPoint,ThreatAreaPostion,ThreatAreaRadius,label);

end