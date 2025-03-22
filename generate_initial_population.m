function initial_population = generate_initial_population(NP, D, Xmin, Xmax)
    a = 0.499;
    % Initialize the bounds for each dimension
    Xmin = ones(1, D) .* Xmin;           
    Xmax = ones(1, D) .* Xmax;
    
    % Initialize the initial population array
    initial_population = zeros(NP, D);
    
    % Generate initial population using Tent map
    for i = 1:NP
        % Generate random initial value in the range [0,1)
        x = rand();
        % Map the random value using Tent map to get initial population
        for j = 1:D
            x = tent_map(x);
            initial_population(i, j) = x;
        end
    end
end

% Tent map function
function x_new = tent_map(x_old)
    a = 0.499;
    if x_old < a
        x_new = x_old/a ;
    else
        x_new = (1 - x_old) /(1-a);
    end
end
