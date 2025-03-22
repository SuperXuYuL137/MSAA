%SAA
function [Best_solution,bestfit,iteration_values] = SAA(NP, Itermax, Xmin, Xmax, D,fobj,label)
    si=0.8;%您可以根据自己的要求调整此值
    %初始化迭代_值数组以进行打印
    % Initialize the bounds for each dimension
    %Best_solution = zeros(1,D);
    % Xmin = ones(1, D) * Xmin;           
    % Xmax = ones(1, D) * Xmax;
    fitness = zeros(1, NP);
    iteration_values = zeros(1, Itermax);
    % Initialize the best solutions array
    %best_solutions = zeros(Itermax, D);
    Iter = 0;
    %步骤2：生成随机初始总体
    %NP_population = Xmin + rand(NP, D) .* (Xmax - Xmin);
    NP_population = initialization(NP, D, Xmin, Xmax,label);
    % %第3步：计算每个人的适合度
    for i = 1:size(NP_population,1)
        fitness(i) = fobj(NP_population(i,:));      
    end
    %主循环
    while Iter < Itermax
        % si = si+(1-si)*rand;
        Iter = Iter + 1;
        for i = 1:size(NP_population,1)
            selected_indices = randperm(size(NP_population,1), 3);
            XBest = NP_population(find(fitness == min(fitness), 1), :);
            bestfit = fobj(XBest);
            Xr1 = NP_population(selected_indices(1), :);
            Xr2 = NP_population(selected_indices(2), :);
            Xr3 = NP_population(selected_indices(3), :);
           %步骤6-9：根据条件更新个体解
            if rand < si
                % 融入levy飞行策略
                Xnew = XBest + rand(1, D) .* (Xr1 - Xr2);
            elseif rand < si
                Xnew = Xr3 + rand(1, D) .* (Xr1 - Xr2);
            elseif rand < si
                Xnew = NP_population(i, :) + rand(1, D) .* (Xr1 - Xr2);
            else
                Xnew = NP_population(i, :) + rand(1, D) .* (Xmax - Xmin);
            end
            %步骤10-12：如果新的解决方案更好，则更新解决方案
            if fobj(Xnew) < fobj(NP_population(i, :)) 
                 % 检查新解是否在搜索空间内
                 %对每个个体一个一个检查是否越界
                 % Return back the search agents that go beyond the boundaries of
                 % the search space，返回超出搜索空间边界的搜索代理
                 Flag4ub=Xnew>Xmax;
                 Flag4lb=Xnew<Xmin;
                 Xnew=(Xnew.*(~(Flag4ub+Flag4lb)))+Xmax.*Flag4ub+Xmin.*Flag4lb;%超过最大值的设置成最大值，超过最小值的设置成最小值
                 % 如果新解在搜索空间内，则更新解决方案
                 NP_population(i, :) = Xnew;
                 fitness(i) = fobj(Xnew);
            end
            
            %% Update the best solution found so far
            if fitness(i) < bestfit
                XBest = NP_population(i, :);
                bestfit = fitness(i);
            end

             
        end
    iteration_values(Iter)= fobj(XBest);
    %返回SAA获得的最佳解决方案
    Best_solution = XBest;
    bestfit = fobj(XBest);
    end
end
