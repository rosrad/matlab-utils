function [er] = compute_er(doas,ref,offset)
if nargin <3, offset = 30; end
assert(length(offset) == 1, 'doas should be column vector.');
S = abs(doas - ref)-offset;
er = sum(S>0,1)/size(doas,1)*100;
