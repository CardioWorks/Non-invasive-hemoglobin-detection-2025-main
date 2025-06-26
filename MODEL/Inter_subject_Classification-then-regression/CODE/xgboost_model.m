function [T_sim1,T_sim2] = xgboost_model(P_train,P_test ,T_train,T_test,M,N)
%%  数据归一化
[p_train, ps_input] = mapminmax(P_train, 0, 1);
p_test = mapminmax('apply', P_test, ps_input);

[t_train, ps_output] = mapminmax(T_train, 0, 1);
t_test = mapminmax('apply', T_test, ps_output);

%%  数据转置
p_train = p_train'; p_test = p_test';
t_train = t_train'; t_test = t_test';
 
%%  设置参数
num_trees = 150;                  % 迭代次数
params.eta = 0.1;                 % 学习率     [0.01, 0.015, 0.025, 0.05, 0.1]
params.objective = 'reg:linear';  % 线性函数
params.max_depth = 25;             % 最大深度    [3, 5, 6, 7, 9, 12, 15, 17, 25]

%%  建立模型
model = xgboost_train(p_train, t_train, params, num_trees);

%%  预测
t_sim1 = xgboost_test(p_train, model);
t_sim2 = xgboost_test(p_test,  model);

%%  数据反归一化
T_sim1 = mapminmax('reverse', t_sim1', ps_output);
T_sim2 = mapminmax('reverse', t_sim2', ps_output);

end