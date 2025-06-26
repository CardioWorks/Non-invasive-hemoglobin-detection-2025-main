function [T_sim1,T_sim2,error1,error2] = SVM_model(P_train,P_test,T_train,T_test,M,N)
    %%  build model
    model = fitrsvm(P_train, T_train, 'KernelFunction', 'gaussian', 'KernelScale', 'auto');
    svmStruct = struct(model);
    C = svmStruct.BoxConstraints;
    kernelFunction = svmStruct.KernelFunction;
if strcmp(kernelFunction, 'rbf') % 检查核函数是否为径向基函数
    sigma = svmStruct.KernelFunctionArgs.sigma; % 获取径向基函数的参数 sigma
    disp(['径向基函数参数 sigma 的值为：', num2str(sigma)]);
else
    disp('该模型不是基于径向基函数的 SVM 模型。');
end
    %%  predict
    T_sim1 = predict(model, P_train);
    T_sim2 = predict(model, P_test);
    
    %%  
    [T_sim1] = OUTPUT_specify(T_sim1);
    [T_sim2] = OUTPUT_specify(T_sim2);

    %%  RMSE
    error1 = sum((T_train == T_sim1)) / M * 100;
    error2 = sum((T_test == T_sim2)) / N * 100;
    
    figure
    cm = confusionchart(T_train, T_sim1);
    cm.Title = 'Confusion Matrix for Train Data';
    cm.ColumnSummary = 'column-normalized';
    cm.RowSummary = 'row-normalized';
    
    figure
    cm = confusionchart(T_test, T_sim2);
    cm.Title = 'Confusion Matrix for Test Data';
    cm.ColumnSummary = 'column-normalized';
    cm.RowSummary = 'row-normalized';
    
    disp(['训练集数据的准确率为：', num2str(error1)])
    disp(['测试集数据的准确率为：', num2str(error2)])
end