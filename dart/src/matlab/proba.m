x2 = zeros(8);
for i=0:7
    x2(i+1,:)=x(i*8+1:i*8+8);
end