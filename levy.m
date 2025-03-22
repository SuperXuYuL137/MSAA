%% Levy Flight function
function LF = levy(NP, D, beta)
    % This function calculates the levy flight step size
    num = gamma(1 + beta) * sin(pi * beta / 2); % used for Numerator
    den = gamma((1 + beta) / 2) * beta * 2^((beta - 1) / 2); % used for Denominator
    sigma = (num / den)^(1 / beta); % Standard deviation

    u = randn(NP, D) * sigma; % u follows normal distribution
    v = randn(NP, D); % v follows normal distribution
    step = u ./ abs(v).^(1 / beta);

    LF = step;
end