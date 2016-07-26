function [y, nseg] = segments(x,seg,fs)
% 
if nargin < 2, error('no enough arguments'),end;
if nargin < 3, fs = 16000;end;

nsampl = size(x,1);
nseg = size(seg,1);

y = cell(nseg,1);

if iscell(seg), seg=cell2mat(seg),end;
if ismatrix(seg) && size(seg,2)==2,
    for i=1:nseg,
        ind = round(seg(i,1)*fs-1):ceil(seg(i,2)*fs);
        y{i} = x(ind,:);
    end
end
