%ISAA
function [bestfit,Best_solution,iteration_values] = ISAA(NP, Itermax, Xmin, Xmax, D,fobj)
    %步骤1：调整SAA参数
    si=0.8;%您可以根据自己的要求调整此值
    NP = NP*10;
    fitness = zeros(1, NP);
    iteration_values = zeros(1, Itermax);
    % Initialize the best solutions array
    %best_solutions = zeros(Itermax, D);
    Iter = 0;
    % Counter for unchanged best solution
    unchanged_best_counter = 0;
    Xc = (Xmin+Xmax)/2;
    %步骤2：生成随机初始总体
    % NP_population = Xmin + rand(NP, D) .* (Xmax - Xmin);
    
    % 使用拉丁超立方抽样初始化种群
    lhs_population = lhsdesign(NP, D);
    % 将拉丁超立方抽样结果缩放到指定范围
    NP_population = Xmin + lhs_population .* (Xmax - Xmin);
    % %第3步：计算每个人的适合度
    for i = 1:size(NP_population,1)
        fitness(i) = fobj(NP_population(i,:));      
    end
    %主循环
    while Iter < Itermax
        si = si+(1-si)*rand;
        %si = si+(1-si)*rand();
        Iter = Iter + 1;
        % Sine Cosine Algorithm (SCA) position update
        
        for i = 1:size(NP_population,1)
            selected_indices = randperm(size(NP_population,1), 3);
            XBest = NP_population(find(fitness == min(fitness), 1), :);
            bestfit = fobj(XBest);
            %随机游走策略
            % 选择一个随机个体
            num_individuals = size(NP_population, 1); % 获取种群中的个体数量
            random_index = randi(num_individuals); % 生成一个随机整数，表示个体的索引
            Xr = NP_population(random_index, :); % 获取随机个体

            % 在主循环中的任意位置（例如在每一代迭代时）添加这行代码：
            X_avg = mean(NP_population, 1);  % 按列计算平均值，即每个维度的平均位置
            r1 =rand; r2 = rand; r3 = rand; r4 = rand;r5 = rand;
            if r3>=0.5
                Xz=Xr-r1*abs(Xr-2*r2*NP_population(i, :));
            else
                Xz=XBest-X_avg-r4*(r5*(Xmax-Xmin)+Xmin);
            end
            if fobj(Xz) < fobj(XBest)
                 Flag4ub=Xz>Xmax;
                 Flag4lb=Xz<Xmin;
                 Xz=(Xz.*(~(Flag4ub+Flag4lb)))+Xmax.*Flag4ub+Xmin.*Flag4lb;%超过最大值的设置成最大值，超过最小值的设置成最小值
                 XBest = Xz;
                 bestfit = fobj(Xz);
            end
            Xr1 = NP_population(selected_indices(1), :);
            Xr2 = NP_population(selected_indices(2), :);
            Xr3 = NP_population(selected_indices(3), :);
           %步骤6-9：根据条件更新个体解
            if rand < si
                % 融入levy飞行策略
                Xnew = XBest +rand(1,D).* (Xr1 - Xr2);
            elseif rand < si
                Xnew = Xr3 + rand(1,D).* (Xr1 - Xr2);
            elseif rand < si
                Xnew = NP_population(i, :) + rand(1,D).* (Xr1 - Xr2);
            else
                Xnew = NP_population(i, :) + rand(1,D).* (Xmax - Xmin);
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
             % if the best solution remains unchanged for 5 consecutive iterations
            unchanged_best_counter = unchanged_best_counter + 1;
            if unchanged_best_counter >= 5
                % 从柯西分布中生成一个随机数
                cauchy_random = tan(pi * (rand - 0.5)); % 生成一个来自 Cauchy(0,1) 的随机数
                % XBest = XBest+XBest * cauchy_random;
                unchanged_best_counter = 0; % Reset the counter after applyingstep
            end
            %% Update the best solution found so far
            if fitness(i) < bestfit
                XBest = NP_population(i, :);
                bestfit = fitness(i);
                unchanged_best_counter = 0; % Reset the counter if best solution changes 重置系数
            end
        end
    iteration_values(Iter)= fobj(XBest);
    %返回SAA获得的最佳解决方案
    Best_solution = XBest;
    bestfit = fobj(XBest);
    end
end
