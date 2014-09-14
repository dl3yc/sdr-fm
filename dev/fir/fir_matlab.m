dlmwrite('input', x, '\n');
[status, cmdout] = system('./fir_matlab < input > output');
y1 = dlmread('output','\n');