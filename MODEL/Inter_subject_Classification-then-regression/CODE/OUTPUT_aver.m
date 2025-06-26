function [val_mean] = OUTPUT_aver(data1,data2)


[~,ins,~] = unique(data1);

t = 1;
for i = 1:length(ins)
    if  i ~= length(ins)
        avg = mean(data2(ins(i):ins(i+1)-1));
    else
        avg = mean(data2(ins(i):end));
    end
    val_mean(t) = avg;
    t = t+1;
end
end