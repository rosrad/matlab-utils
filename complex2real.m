function Y = complex2real(X)
if isreal(X), Y = X; end;
[d1,d2,d3] = size(X);
R = real(X); I = imag(X);
Y = [R(:), I(:)];
Y = reshape(Y.', d1*2, d2,d3);