function [predict] = Outcome_norms(val,result)
for class_index = 1:length(result)
    switch val(class_index)
        case 0
            if result(class_index) >=0 && result(class_index) <=1.5
                predict(class_index) = 0;
            else
                predict(class_index) = 1;
            end
        case 1
            if result(class_index) >=0.5 && result(class_index) <=1.5
                predict(class_index) = 1;
            else
                predict(class_index) = round(result(class_index));
            end
        case 2
            if result(class_index) >=0.5 && result(class_index) <=2
                predict(class_index) = 2;
               else
                predict(class_index) = 1;
            end
    end
end
end