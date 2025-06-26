function [T_sim1,T_sim2] = xgboost_model(P_train,P_test ,T_train,T_test,M,N)
%%  ���ݹ�һ��
[p_train, ps_input] = mapminmax(P_train, 0, 1);
p_test = mapminmax('apply', P_test, ps_input);

[t_train, ps_output] = mapminmax(T_train, 0, 1);
t_test = mapminmax('apply', T_test, ps_output);

%%  ����ת��
p_train = p_train'; p_test = p_test';
t_train = t_train'; t_test = t_test';
 
%%  ���ò���
num_trees = 150;                  % ��������
params.eta = 0.1;                 % ѧϰ��     [0.01, 0.015, 0.025, 0.05, 0.1]
params.objective = 'reg:linear';  % ���Ժ���
params.max_depth = 25;             % ������    [3, 5, 6, 7, 9, 12, 15, 17, 25]

%%  ����ģ��
model = xgboost_train(p_train, t_train, params, num_trees);

%%  Ԥ��
t_sim1 = xgboost_test(p_train, model);
t_sim2 = xgboost_test(p_test,  model);

%%  ���ݷ���һ��
T_sim1 = mapminmax('reverse', t_sim1', ps_output);
T_sim2 = mapminmax('reverse', t_sim2', ps_output);

end