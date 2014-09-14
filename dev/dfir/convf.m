function [ Y ] = convf( X, H, fraction )
%CONV convolution with signed fixed format
%   X := input signal
%   H := kernel signal

    Xlen = length(X);
    Hlen = length(H);
    Ylen = Xlen + Hlen -1;
    Y = zeros(1,Ylen);

    for n = 1:Ylen
        if n < Hlen
            kmin = 1;
        else
            kmin = n - Hlen +1;
        end
        if n < Xlen
            kmax = n;
        else
            kmax = Xlen;
        end
        for k = kmin:kmax
            Y(n) = Y(n) + X(k) * H(n-k+1) / power(2,fraction);
        end
    end
end

