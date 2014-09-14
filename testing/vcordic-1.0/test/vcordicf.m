a = 0.8;
b = 0.1;

a = fixed(a,0,15);
b = fixed(b,0,15);

n = 15;

x = zeros(1,n+1);
y = zeros(1,n+1);
z = zeros(1,n+1);

if a >= 0
    x(1) = a;
    y(1) = b;
    z(1) = 0;
elseif b >= 0
    x(1) = b;
    y(1) = -a;
    z(1) = 90;
else
    x(1) = -b;
    y(1) = a;
    z(1) = -90;
end

for k = 2:n+1
    if x(k-1) >= 0
        x(k) = x(k-1) - y(k-1) / 2^(k-2);
        y(k) = y(k-1) + x(k-1) / 2^(k-2);
        z(k) = z(k-1) - atan(1/2^(k-2))*(power(2,23)-1)/pi;
    else
        x(k) = x(k-1) + y(k-1) / 2^(k-2);
        y(k) = y(k-1) - x(k-1) / 2^(k-2);
        z(k) = z(k-1) + atan(1/2^(k-2))*(power(2,23)-1)/pi;
    end
end

cordic=y(n+1)/1.6467 / 2^15
matlab=abs(a/2^15 + 1i*b/2^15)
phase=z(n+1) / 2^23*180 % buggy!
matlab=angle(a/2^15 + 1i*b/2^15)/(2*pi)*360