%MSAA
function [Best_solution,bestfit,iteration_values] = MSAA(NP, Itermax, Xmin, Xmax, D,fobj,label)
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
    % levy参数
    beta = 1.5;
    % b = 1;
    % l = -1 + rand;
    % Xmin = ones(1, D) * Xmin;           
    % Xmax = ones(1, D) * Xmax;
    fitness = zeros(1, NP);
    iteration_values = zeros(1, Itermax);
    % Initialize the best solutions array
    %best_solutions = zeros(Itermax, D);
    Iter = 0;
    % Counter for unchanged best solution
    unchanged_best_counter = 0;
    % DE-Q-learning系数
    % Generating F value randomly between 0.4 and 1
    F = 0.4 + rand * (1 - 0.4);
    %步骤2：生成随机初始总体
    %NP_population = Xmin + rand(NP, D) .* (Xmax - Xmin);
    NP_population = initialization(NP, D, Xmin, Xmax,label);

    % Initialize Q-learning parameters
    action_num = 3;
    Reward_table = zeros(action_num, action_num, NP);
    Q_table = zeros(action_num, action_num, NP);
    cur_state = randi(action_num);
    gamma = 0.5;
    lambda_initial = 0.9;
    lambda_final = 0.1;


    % %第3步：计算每个人的适合度
    for i = 1:size(NP_population,1)
        fitness(i) = fobj(NP_population(i,:));      
    end
    %主循环
    while Iter < Itermax
        si = si+(1-si)*Map(1,1,label);
        %si = si+(1-si)*rand();
        Iter = Iter + 1;
        %改进：自适应惯性权重
        w = power(wmin*(wmax/wmin),1/(1 + c/Iter));
        % Sine Cosine Algorithm (SCA) position update
        r1 = (1 - (Iter / Itermax)^alpha)^(1 / alpha);r2 = rand * 2 * pi; r3 = 2 * rand; r4 = rand;
        for i = 1:size(NP_population,1)
           %% Refraction learning

            x = NP_population(i, :);
            k = (1 + (3 * Iter / Itermax)^0.5)^8;
            x_star = (Xmin + Xmax) / 2 + (Xmin + Xmax) / (2 * k) - x / k;
            
            % Boundary check for x_star
            Flag4ub = x_star > Xmax;
            Flag4lb = x_star < Xmin;
            x_star = (x_star .* (~(Flag4ub + Flag4lb))) + Xmax .* Flag4ub + Xmin .* Flag4lb;
            
            % Calculate the fitness of the new position
            fitness_star = fobj(x_star);
            
            % Greedy selection
            if fitness_star < fobj(NP_population(i, :))
                NP_population(i, :) = x_star;
            end
            selected_indices = randperm(size(NP_population,1), 3);
            XBest = NP_population(find(fitness == min(fitness), 1), :);
            bestfit = fobj(XBest);
            Xr1 = NP_population(selected_indices(1), :);
            Xr2 = NP_population(selected_indices(2), :);
            Xr3 = NP_population(selected_indices(3), :);
            %% Q-learning based action selection
            if (Q_table(cur_state, 1, i) >= Q_table(cur_state, 2, i) && Q_table(cur_state, 1, i) >= Q_table(cur_state, 3, i))
                action = 1;
            elseif (Q_table(cur_state, 2, i) >= Q_table(cur_state, 1, i) && Q_table(cur_state, 2, i) >= Q_table(cur_state, 3, i))
                action = 2;
            else
                action = 3;
            end
            %% Action based position update and DE celue
            if action == 1
                XQ = Xr1 + F .* (Xr2 - Xr3);
            elseif action == 2
                if rand > 0.5
                    XQ = NP_population(i, :) + F .* (Xr1 - Xr2);
                else
                    XQ = NP_population(i, :) + F .* (Xr2 - Xr3);
                end
            else
                XQ = XBest + levy(1, D, beta) .* (Xr1 - Xr3);
            end

            %% Boundary check and fitness evaluation
            Flag4ub = XQ > Xmax;
            Flag4lb = XQ < Xmin;
            XQ = (XQ .* (~(Flag4ub + Flag4lb))) + Xmax .* Flag4ub + Xmin .* Flag4lb;
            new_fitness = fobj(XQ);
            %% Q-learning reward update
            if new_fitness < fitness(i)
                NP_population(i, :) = XQ;
                fitness(i) = new_fitness;
                Reward_table(cur_state, action, i) = 1;
            else
                Reward_table(cur_state, action, i) = -1;
            end

           %步骤6-9：根据条件更新个体解
            if rand < si
                % 融入levy飞行策略
                Xnew = XBest +levy(1,D,beta).*rand(1, D) .* (Xr1 - Xr2);
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
            %% Q-value update
            r = Reward_table(cur_state, action, i);
            maxQ = max(Q_table(action, :, i));
            lambda = (lambda_initial + lambda_final) / 2 - (lambda_initial - lambda_final) / 2 * cos(pi * (1 - Iter / Itermax));
            Q_table(cur_state, action, i) = Q_table(cur_state, action, i) + lambda * (r + gamma * maxQ - Q_table(cur_state, action, i));
            cur_state = action;

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
