clear all
fs = 16000;
file_write_after = '../2000H-CHN-4MIC-0DEG/';
mkdir(file_write_after);

file_read_path = '/10T/jiangwei/2000H-CHN/';
cmd = ['find',' ',file_read_path,' ','-depth',' ','-name',' ','"*.wav"',' ','>',' ','wav_list.txt'];
dos(cmd);

fid = fopen('wav_list.txt');
pcm_info = textscan(fid,'%s');
fclose(fid);
pcm_info = pcm_info{1};
pcm_num = length(pcm_info);

h = wavread('IR.wav');
h = 2.*h;
noise_k = wavread('4mic_aircondition.wav');
noise_k = noise_k(2*fs:end,:);
noise_b = wavread('4mic_background_noise.wav');
noise_b = noise_b(2*fs:end,:);
len_b = length(noise_b);
len_k = length(noise_k);
TH_max = 32765/32767;

bias = 16000*0.128;

pcm_num_InOneFolder = 1000;
folder_num = floor(pcm_num/pcm_num_InOneFolder)
%matlabpool open local 12;
tic
for folder_i = 1:folder_num
    mkdir([file_write_after,sprintf('%05d',folder_i),'/']);
    if mod(folder_i,3) == 0
        one_len = 3*pcm_num_InOneFolder*fs;
        beg_noi = round(rand(1)*(len_k-one_len-10));
        noise = noise_k(beg_noi+1:beg_noi+one_len,:);
        len = one_len;
    else
        one_len = 3*pcm_num_InOneFolder*fs;
        beg_noi = round(rand(1)*(len_b-one_len-10));
        noise = noise_b(beg_noi+1:beg_noi+one_len,:);
        len = one_len;
    end
    pcm_beg = (folder_i-1)*pcm_num_InOneFolder;
    pcm_info_tmp = pcm_info(pcm_beg+1:pcm_beg+pcm_num_InOneFolder);
    for i = 1:pcm_num_InOneFolder
        pcm_name = pcm_info_tmp{i};
        data = pcmread(pcm_name);
		data = data(23:end);
        if max(max(abs(data))) < TH_max
            data_len = length(data);
            s = zeros(data_len,4);
            for ch = 1:4
                tmp = conv(data,h(:,ch));
                s(:,ch) = tmp(bias:bias+data_len-1,:);
            end
            power_s = var(s(:,1));
            
            beg_noi = round(rand(1)*(len-data_len-10));
            noi = noise(beg_noi+1:beg_noi+data_len,:);
            power_n = var(noi(:,1));
            
            SNR = round(3+rand(1)*12);
            ration = sqrt(power_s/(power_n*10^(SNR/10)));
            
            y = s+ration.*noi;
            
            key1 = strfind(pcm_name,'/');
            file_name = pcm_name(key1(end)+1:end);
            key2 = strfind(file_name,'.wav');
            tmp_file = ['tmp/',file_name(1:key2(end)),'pcm']
			y = y/max(max(abs(y)))*0.618;
            %wavwrite(y,fs,tmp_file);
			y = reshape(y',1,size(y,1)*size(y,2));
			y = y';
			pcmwrite(y,tmp_file);
            par1 = tmp_file;
            par2 = [file_write_after,sprintf('%05d',folder_i),'/',strrep(file_name,'wav','pcm')];
			degree = round(rand()*40-20);
            cmd = ['./UniMicArray_Test 1 dat_4mic 1 ',sprintf('%d',degree),' ',par2,' ',par1];
			dos(cmd);
			fid = fopen(par2,'rb');
			data = fread(fid,'int16');
			fclose(fid);
			newData = data/max(abs(data))*0.618;
			wavwrite(newData,16000,strrep(par2,'.pcm','.wav'));
			cmd = ['rm' ' ',par2];
			dos(cmd);
            cmd = ['rm',' ',tmp_file];
            dos(cmd);
        end
    end
    
end
toc
%matlabpool close;
