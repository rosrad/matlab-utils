%% spectrum: plot 2-d spectrum figure
function [] = spectrum(x)
assert (ndims(x) == 2, 'input should be 2-d matrix.');
[m, n] = size(x);
assert (m>1 && n>1, 'input should be 2-d matrix.');
mesh(x),view(0,90);
