function [ output_args ] = Sava_proj_Mtx( data, imageSize )


[m,n] = size(data)
%name=[num2str(m) '.dat'];
%fOut = sprintf('%d.dat',m); 
%file = fopen( fOut,'w');
%fprintf(file,full(sparse));
%dlmwrite([num2str(imageSize) '.dat'],full(sparse));

save([m '.dat'] ,'data');
end

