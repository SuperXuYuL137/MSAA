
% 调用函数生成并展示 tent 映射的图像

function tle = Map_name(label)

if label==1
        %chebyshev 映射
        tle = 'chebyshev';
elseif label==2
        % Circle 映射
        tle = 'Circle';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif label==3
       % Gauss/mouse 混沌映射 
       tle = 'Gauss/mouse';
elseif label==4
       % Piecewise 混沌映射
       tle = 'Piecewise';
elseif label==5
       % Fuch 混沌映射
       tle = 'Fuch';
elseif label==6
       % Cubic 混沌映射
       tle = 'Cubic';
elseif label==7
       % ICMIC 混沌映射
       tle = 'ICMIC';
elseif label==8
       % Tent-Logistic-Cosine混沌映射
       tle = 'Tent-Logistic-Cosine';
elseif label==9
       % Sine-Tent-Cosine混沌映射
       tle = 'Sine-Tent-Cosine';
elseif label==10
       % Logistic-Sine-Cosine混沌映射
       tle = 'Logistic-Sine-Cosine';
% elseif label==11
%        % Cubic混沌映射
%        tle = 'Cubic';
% elseif label==12
%        % Logistic-Tent 混沌映射
%        tle = 'Logistic-Tent';
% elseif label==13
%        % Bernoulli 混沌映射
%        tle = 'Bernoulli';
% elseif label==14
%        % Kent 混沌映射
%        tle = 'Kent';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
else
    %无映射
   tle = '无映射';
end
end
