function [ output_args ] = Sava_proj_Mtx( data, imageSize )


[m,n] = size(data)
%name=[num2str(m) '.dat'];
%fOut = sprintf('%d.dat',m); 
%file = fopen( fOut,'w');
%fprintf(file,full(sparse));
%dlmwrite([num2str(imageSize) '.dat'],full(sparse));

pw=java.io.PrintWriter(java.io.FileWriter([num2str(imageSize) '.dat']));
line=num2str(0:size(data,2)-1);
pw.println(line);
for index=1:m
    disp(index);
    line=num2str(full(data(index,:)));
    pw.println(line);
end
pw.flush();
pw.close();
end

