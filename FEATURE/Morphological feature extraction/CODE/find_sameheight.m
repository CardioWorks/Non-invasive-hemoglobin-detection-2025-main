function [j] = find_sameheight(dir,num_onset,height,data)
%dir:direction(0:left,1:right)

j = num_onset;
while (data(num_onset)-data(j)) <= height
    switch dir
        case 0
            j = j-1;
        case 1
            j = j+1;
    end
end

end
