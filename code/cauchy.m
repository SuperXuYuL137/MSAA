function val = cauchy(loc, scale)
    % Generate Cauchy-distributed random numbers
    val = loc + scale * tan(pi *  - 0.5);
end