%% load default values
clear all;
fs = 96e3;
n = 128;

%% input signal generation
f_in1 = 10e3;
f_in2 = 20e3;
dt = 1/fs;
t = 0:dt:10e-3;
x = 0.5*exp(1i*2*pi*f_in1*t) + 0.5*exp(1i*2*pi*f_in2*t);

I = zeros(1,length(x));
Q = zeros(1,length(x));
% convertion to signed fixed-point format Q0.26
I=fixed(real(x),0,26);
Q=fixed(imag(x),0,26);

%% signal processing
% convolution
%I = convf(I,H,15);
%Q = convf(Q,H,15);
fid = fopen('input','w');
for n=1:length(I)
    fprintf(fid, '%d\n', int32(I(n)));
end
fclose(fid);
[~,~] = system('./dfir_matlab < input > output');
I = dlmread('output','\n');

fid = fopen('input','w');
for n=1:length(Q)
    fprintf(fid, '%d\n', int32(Q(n)));
end
fclose(fid);
[~,~] = system('./dfir_matlab < input > output');
Q = dlmread('output','\n');
fs=fs/2;

% convertion back to double
I = double(I')/2^26;
Q = double(Q')/2^26;

%% output
y = [(I+1i*Q).*hann(length(I))' zeros(1,2^16)];
Y = real(abs(fftshift(fft(y))));
Y = Y./max(Y);

df=fs/length(Y);
f=-fs/2:df:fs/2-df;
plot(f,20*log(Y));
%plot3(t,I,Q)
%plot(Q);
