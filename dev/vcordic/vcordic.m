a = -1;
b = 0;

n = 15;

x = zeros(1,n+1);
y = zeros(1,n+1);
z = zeros(1,n+1);

if a >= 0
    x(1) = a;
    y(1) = b;
    z(1) = 0;
elseif y >= 0
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
        z(k) = z(k-1) + atan(1/2^(k-2))/(2*pi)*360;
    else
        x(k) = x(k-1) + y(k-1) / 2^(k-2);
        y(k) = y(k-1) - x(k-1) / 2^(k-2);
        z(k) = z(k-1) - atan(1/2^(k-2))/(2*pi)*360;
    end
end

cordic=y(n+1)/1.6467
matlab=abs(a + 1i*b)
phase=z(n+1)
matlab=angle(a + 1i*b)/(2*pi)*360