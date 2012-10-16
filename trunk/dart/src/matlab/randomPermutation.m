function sigma = randomPermutation(d)
    numbers = 1:d;
    sigma = zeros(1,d);
    s_idx = 1;
    while size(numbers)>0
        num_idx = randi(size(numbers),1);
        sigma(s_idx) = numbers(num_idx);
        %numsize = size(numbers);
        %tmp = [numbers(1:(num_idx-1)),numbers((num_idx+1):numsize)];
        %numbers = tmp;
        numbers(num_idx) = [];
        s_idx = s_idx+1;
    end
end