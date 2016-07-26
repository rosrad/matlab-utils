%% normalization: function description
function [y] = normalization(x,dim)
if nargin <2, dim=1;end;
y = bsxfun(@minus, x, min(x,[],dim));
y = bsxfun(@rdivide, y, max(x,[],dim));