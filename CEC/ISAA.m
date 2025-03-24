%ISAA
function [Best_solution,bestfit,iteration_values] = ISAA(NP, Itermax, Xmin, Xmax, D,fobj,label)
    %步骤1：调整SAA参数
    si=0.8;%您可以根据自己的要求调整此值
    %初始化迭代_值数组以进行打印
    % Initialize the bounds for each dimension
    %Best_solution = zeros(1,D);
    wmin=0.4;
    wmax=0.9;
    c = 10;
    % Exponent for r1 calculation
    alpha = 1.6; 
    fitness = zeros(1, NP);
    iteration_values = zeros(1, Itermax);
    % Initialize the best solutions array
    %best_solutions = zeros(Itermax, D);
    Iter = 0;
    % Counter for unchanged best solution
    unchanged_best_counter = 0;
    %步骤2：生成随机初始总体
    %NP_population = Xmin + rand(NP, D) .* (Xmax - Xmin);
    NP_population = initialization(NP, D, Xmin, Xmax,label);

    %中心解
    Xc=(Xmin+Xmax)/2;
    % %第3步：计算每个人的适合度
    for i = 1:size(NP_population,1)
        fitness(i) = fobj(NP_population(i,:));      
    end
    %主循环
    while Iter < Itermax
        si = si+(1-si)*Map(1,1,4);
        %si = si+(1-si)*rand();
        Iter = Iter + 1;
        % %改进：自适应惯性权重
        w = power(wmin*(wmax/wmin),1/(1 + c/Iter));
        % Sine Cosine Algorithm (SCA) position update
        r1 = (1 - (Iter / Itermax)^alpha)^(1 / alpha);r2 = rand * 2 * pi; r3 = 2 * rand; r4 = rand;
        for i = 1:size(NP_population,1)
            selected_indices = randperm(size(NP_population,1), 3);
            XBest = NP_population(find(fitness == min(fitness), 1), :);
            bestfit = fobj(XBest);

            %随机中心解
            xl = ceil(NP*rand);
            while xl==i
                xl = ceil(NP*rand);
            end
            xr = ceil(NP*rand);
            while xr==i
                xr = ceil(NP*rand);
            end
            Xc_rand=rand;
            if Xc_rand<0.5
                Xz=Xc+(NP_population(xr,:)-Xc).*rand();
            else
                Xz=Xc+(Xc-NP_population(xl,:)).*rand();
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
                Xnew = XBest +Map(1,D,4).* (Xr1 - Xr2);
            elseif rand < si
                Xnew = Xr3 + Map(1,D,4).* (Xr1 - Xr2);
            elseif rand < si
                Xnew = NP_population(i, :) + Map(1,D,4).* (Xr1 - Xr2);
            else
                Xnew = NP_population(i, :) + Map(1,D,4).* (Xmax - Xmin);
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
             % SCA step if the best solution remains unchanged for 5 consecutive iterations
            unchanged_best_counter = unchanged_best_counter + 1;
            if unchanged_best_counter >= 5
                Pt = XBest;
                if r4 >= 0.5
                    Xs = w * NP_population(i, :) + r1 * sin(r2) * abs(r3 * Pt - NP_population(i, :));
                else
                    Xs = w * NP_population(i, :) + r1 * cos(r2) * abs(r3 * Pt - NP_population(i, :));
                end
                
                % Boundary check for Xnew
                Flag4ub = Xs > Xmax;
                Flag4lb = Xs < Xmin;
                Xs = (Xs .* (~(Flag4ub + Flag4lb))) + Xmax .* Flag4ub + Xmin .* Flag4lb;
                
                % Update solution if the new solution is better
                if fobj(Xs) < fobj(NP_population(i, :))
                    NP_population(i, :) = Xs;
                    fitness(i) = fobj(Xs);
                end
                unchanged_best_counter = 0; % Reset the counter after applying SCA step
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
