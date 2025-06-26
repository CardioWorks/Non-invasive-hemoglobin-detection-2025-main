function  [T_train,T_test,T_sim1,T_sim2,error1,R1,mae1,error2,R2,mae2]= integrated_regressor(data1_Train,data1_Test,data2_Train,data2_Test,data3_Train,data3_Test,feature_column)
%% 三个Xgboost模型
P1_train = data1_Train(:,feature_column+9);P1_test = data1_Test(:,feature_column+9) ;T1_train = data1_Train(:,2) ;T1_test = data1_Test(:,2);M = size(P1_train,1);N = size(P1_test,1);
[T1_sim1,T1_sim2] = xgboost_model(P1_train',P1_test' ,T1_train',T1_test',M,N);

P2_train = data2_Train(:,feature_column+9);P2_test = data2_Test(:,feature_column+9) ;T2_train = data2_Train(:,2) ;T2_test = data2_Test(:,2);M = size(P2_train,1);N = size(P2_test,1);
[T2_sim1,T2_sim2] = xgboost_model(P2_train',P2_test' ,T2_train',T2_test',M,N);

P3_train = data3_Train(:,feature_column+9);P3_test = data3_Test(:,feature_column+9) ;T3_train = data3_Train(:,2) ;T3_test = data3_Test(:,2);M = size(P3_train,1);N = size(P3_test,1);
[T3_sim1,T3_sim2] = xgboost_model(P3_train',P3_test' ,T3_train',T3_test',M,N);

%% add label
T1_sim1_id = [data1_Train(:,1:2) T1_sim1'];
T2_sim1_id = [data2_Train(:,1:2) T2_sim1'];
T3_sim1_id = [data3_Train(:,1:2) T3_sim1'];
T1_sim2_id = [data1_Test(:,1:2) T1_sim2'];
T2_sim2_id = [data2_Test(:,1:2) T2_sim2'];
T3_sim2_id = [data3_Test(:,1:2) T3_sim2'];

T_sim1_id= sortrows([T1_sim1_id;T2_sim1_id;T3_sim1_id],1);
T_sim2_id= sortrows([T1_sim2_id;T2_sim2_id;T3_sim2_id],1);

%% average
[T_train] = OUTPUT_aver(T_sim1_id(:,1),T_sim1_id(:,2));
[T_sim1] = OUTPUT_aver(T_sim1_id(:,1),T_sim1_id(:,3));

[T_test] = OUTPUT_aver(T_sim2_id(:,1),T_sim2_id(:,2));
[T_sim2] = OUTPUT_aver(T_sim2_id(:,1),T_sim2_id(:,3));
M = length(T_train);N = length(T_test);

%% calculate index
error1 = sqrt(sum((T_sim1 - T_train).^2) ./ M);
error2 = sqrt(sum((T_sim2 - T_test ).^2) ./ N);
R1 = 1 - norm(T_train - T_sim1)^2 / norm(T_train - mean(T_train))^2;
R2 = 1 - norm(T_test -  T_sim2)^2 / norm(T_test -  mean(T_test ))^2;
mae1 = sum(abs(T_sim1 - T_train)) ./ M ;
mae2 = sum(abs(T_sim2 - T_test )) ./ N ;

figure
plot(1: M, T_train, 'r-*', 1: M, T_sim1, 'b-o', 'LineWidth', 1)
legend('真实值','预测值','FontSize',14,'FontName','宋体')
xlabel('预测样本','FontSize',14,'FontName','宋体')
ylabel('预测结果','FontSize',14,'FontName','宋体')
string = {'xgboost训练集预测结果对比';['RMSE=' num2str(error1)]};
title(string,'FontSize',14,'FontName','宋体')
xlim([1, M])
grid

figure
plot(1: N, T_test, 'r-*', 1: N, T_sim2, 'b-o', 'LineWidth', 1)
legend('真实值','预测值','FontSize',14,'FontName','宋体')
xlabel('预测样本','FontSize',14,'FontName','宋体')
ylabel('预测结果','FontSize',14,'FontName','宋体')
string = {'xgboost测试集预测结果对比';['RMSE=' num2str(error2)]};
title(string,'FontSize',14,'FontName','宋体')
xlim([1, N])
grid

end