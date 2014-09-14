function [ y ] = fixed( x, integer, fraction )
%FIXED Summary of this function goes here
%   Detailed explanation goes here
    y = zeros(1,length(x));
    for n = 1:length(x)
        if x(n) == power(2,integer)
            y(n) = power(2,fraction)-1;
        elseif x(n) == -power(2,integer)
            y(n) = power(2,fraction);
        else
            y(n) = x(n) * power(2,fraction);
        end
    end
end

