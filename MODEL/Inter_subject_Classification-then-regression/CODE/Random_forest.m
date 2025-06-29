function [T_sim1,T_sim2,error1,error2,R1,R2,mae1,mae2,mbe1,mbe2] = Random_forest(P_train,P_test ,T_train,T_test,M,N)
%%  数据归一化
[p_train, ps_input] = mapminmax(P_train, 0, 1);
p_test = mapminmax('apply', P_test, ps_input);

[t_train, ps_output] = mapminmax(T_train, 0, 1);
t_test = mapminmax('apply', T_test, ps_output);

%%  转置以适应模型a
p_train = p_train'; p_test = p_test';
t_train = t_train'; t_test = t_test';

%%  训练模型
trees = 100;                                      % 决策树数目
leaf  = 5;                                        % 最小叶子数
OOBPrediction = 'on';                             % 打开误差图
OOBPredictorImportance = 'on';                    % 计算特征重要性
Method = 'regression';                            % 分类还是回归
net = TreeBagger(trees, p_train, t_train, 'OOBPredictorImportance', OOBPredictorImportance,...
      'Method', Method, 'OOBPrediction', OOBPrediction, 'minleaf', leaf);
importance = net.OOBPermutedPredictorDeltaError;  % 重要性

%%  仿真测试
t_sim1 = predict(net, p_train);
t_sim2 = predict(net, p_test );

%%  数据反归一化
T_sim1 = mapminmax('reverse', t_sim1, ps_output);
T_sim2 = mapminmax('reverse', t_sim2, ps_output);

%%  均方根误差
error1 = sqrt(sum((T_sim1' - T_train).^2) ./ M);
error2 = sqrt(sum((T_sim2' - T_test ).^2) ./ N);

%%  绘图
figure
plot(1: M, T_train, 'r-*', 1: M, T_sim1, 'b-o', 'LineWidth', 1)
legend('真实值','预测值','FontSize',14,'FontName','宋体')
xlabel('预测样本','FontSize',14,'FontName','宋体')
ylabel('预测结果','FontSize',14,'FontName','宋体')
string = {'Random_forest训练集预测结果对比'; ['RMSE=' num2str(error1)]};
title(string,'FontSize',14,'FontName','宋体')
xlim([1, M])
grid

figure
plot(1: N, T_test, 'r-*', 1: N, T_sim2, 'b-o', 'LineWidth', 1)
legend('真实值','预测值','FontSize',14,'FontName','宋体')
xlabel('预测样本','FontSize',14,'FontName','宋体')
ylabel('预测结果','FontSize',14,'FontName','宋体')
string = {'Random_forest测试集预测结果对比';['RMSE=' num2str(error2)]};
title(string,'FontSize',14,'FontName','宋体')
xlim([1, N])
grid

%%  绘制误差曲线
figure
plot(1 : trees, oobError(net), 'b-', 'LineWidth', 1)
legend('误差曲线','FontSize',14,'FontName','宋体')
xlabel('决策树数目','FontSize',14,'FontName','宋体')
ylabel('误差','FontSize',14,'FontName','宋体')
xlim([1, trees])
grid

%%  绘制特征重要性
figure
bar(importance)
legend('重要性','FontSize',14,'FontName','宋体')
xlabel('特征','FontSize',14,'FontName','宋体')
ylabel('重要性','FontSize',14,'FontName','宋体')

%%  相关指标计算
%  R2
R1 = 1 - norm(T_train - T_sim1')^2 / norm(T_train - mean(T_train))^2;
R2 = 1 - norm(T_test -  T_sim2')^2 / norm(T_test -  mean(T_test ))^2;

disp(['训练集数据的R2为：', num2str(R1)])
disp(['测试集数据的R2为：', num2str(R2)])

%  MAE
mae1 = sum(abs(T_sim1' - T_train)) ./ M;
mae2 = sum(abs(T_sim2' - T_test )) ./ N;

disp(['训练集数据的MAE为：', num2str(mae1)])
disp(['测试集数据的MAE为：', num2str(mae2)])

%  MBE
mbe1 = sum(T_sim1' - T_train) ./ M ;
mbe2 = sum(T_sim2' - T_test ) ./ N ;

disp(['训练集数据的MBE为：', num2str(mbe1)])
disp(['测试集数据的MBE为：', num2str(mbe2)])

T_sim1 = T_sim1';
T_sim2 = T_sim2';
end