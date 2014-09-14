%% start
clear all;
[Y,FS,NBITS]=wavread('input.wav');
I=Y(820000:830000,1);
Q=Y(820000:830000,2);
X = I + 1i * Q;
fil = firhalfband(30,0.2);
%I = filter(fil,1,I);
%Q = filter(fil,1,Q);

%% vhdl
I = int32(I * 2^26);
Q = int32(Q * 2^26);

fid = fopen('input','w');
for n=1:length(I)
    fprintf(fid, '%d\n', int32(I(n)));
    fprintf(fid, '%d\n', int32(Q(n)));
end
fclose(fid);
disp('processing');
[~,~] = system('./pfd_matlab < input > output');
IQ = dlmread('output','\n');

I = IQ(1:2:length(IQ));
Q = IQ(2:2:length(IQ));

I = I / 2^26;
Q = Q / 2^26;

F = I + 1i*Q;

%% test
%F = zeros(1,length(X)-1);
%for n = 2:length(X)
%    Fold = X(n-1);
%    F(n) = X(n) * conj(Fold);
%end

%F=X;

I = real(F)./abs(F);
Q = imag(F)./abs(F);
Idiff = diff(I);
Qdiff = diff(Q);
out = FS/(2*pi*12500) * (Idiff .* Q(2:length(Q)) - Qdiff .* I(2:length(I)));
out = filter(fil,1,out);
wavwrite(out,FS,NBITS,'output.wav');