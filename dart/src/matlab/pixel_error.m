function c = pixel_error(x,y)
    c = 0;
    for i = 1:size(x,1)
        if x(i)~=y(i)
            c = c+1;
        end
    end
end