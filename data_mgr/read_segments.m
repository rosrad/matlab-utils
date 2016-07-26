function [y,nseg] = read_segments(tag,segfile)
    if nargin < 1, error('no enough arguments!');end;
    pcmfile = [tag '.pcm'];
    if nargin < 2, segfile = [tag '.seg'];end;
    
    fs =16000;
    x = readpcm(pcmfile);
    seg =read_segfile(segfile);
    [y,nseg] = segments(x,seg,fs);


function seg = read_segfile(segfile)
    fid = fopen(segfile);
    seg = textscan(fid,'%f64 %f64 %*[^\n]');
    seg = cell2mat(seg);
    fclose(fid);
    

