function [x] = readpcm(pcmfile,nchan)

% 
if nargin < 1, error('no enough arguments'),end;
if nargin < 2, nchan=4;end;


[fp, errmsg] = fopen(pcmfile, 'rb');
if fp < 0, error (errmsg); end;
d = fread(fp,'int16');
fclose(fp);
len=size(d,1);
n = floor(len/nchan)*nchan;
x = reshape(d(1:n),nchan,[]).';

