function [data1,data2,data3]= Input_Classification(input,data)
    data1 = data(input == 0, :);
    data2 = data(input == 1, :);
    data3 = data(input == 2, :);
end