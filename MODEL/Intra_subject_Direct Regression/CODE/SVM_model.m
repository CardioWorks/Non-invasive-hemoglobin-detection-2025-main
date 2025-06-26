function [T_sim1,T_sim2,error1,error2,R1,R2,mae1,mae2,mbe1,mbe2] = SVM_model(P_train,P_test ,T_train,T_test,M,N)
%%  
[p_train, ps_input] = mapminmax(P_train, 0, 1);
p_test = mapminmax('apply', P_test, ps_input);

[t_train, ps_output] = mapminmax(T_train, 0, 1);
t_test = mapminmax('apply', T_test, ps_output);

%%  
p_train = p_train'; p_test = p_test';
t_train = t_train'; t_test = t_test';

%% 
c = 4.0;   
g = 0.8;   
cmd = [' -t 2',' -c ',num2str(c),' -g ',num2str(g),' -s 3 -p 0.01'];
model = svm_train(t_train, p_train, cmd);

%%  
[t_sim1, error1] = svmpredict(t_train, p_train, model);
[t_sim2, error2] = svmpredict(t_test , p_test , model);

%% 
T_sim1 = mapminmax('reverse', t_sim1, ps_output);
T_sim2 = mapminmax('reverse', t_sim2, ps_output);

%%  
error1 = sqrt(sum((T_sim1' - T_train).^2) ./ M);
error2 = sqrt(sum((T_sim2' - T_test ).^2) ./ N);

%%  
figure
plot(1: M, T_train, 'r-*', 1: M, T_sim1, 'b-o', 'LineWidth', 1)
legend('��ʵֵ','Ԥ��ֵ','FontSize',14,'FontName','����')
xlabel('Ԥ������','FontSize',14,'FontName','����')
ylabel('Ԥ����','FontSize',14,'FontName','����')
string = {'SVMѵ����Ԥ�����Ա�'; ['RMSE=' num2str(error1)]};
title(string,'FontSize',14,'FontName','����')
xlim([1, M])
grid

figure
plot(1: N, T_test, 'r-*', 1: N, T_sim2, 'b-o', 'LineWidth', 1)
legend('��ʵֵ','Ԥ��ֵ','FontSize',14,'FontName','����')
xlabel('Ԥ������','FontSize',14,'FontName','����')
ylabel('Ԥ����','FontSize',14,'FontName','����')
string = {'SVM���Լ�Ԥ�����Ա�';['RMSE=' num2str(error2)]};
title(string,'FontSize',14,'FontName','����')
xlim([1, N])
grid

%% 
%  R2
R1 = 1 - norm(T_train - T_sim1')^2 / norm(T_train - mean(T_train))^2;
R2 = 1 - norm(T_test -  T_sim2')^2 / norm(T_test -  mean(T_test ))^2;

disp(['ѵ�������ݵ�R2Ϊ��', num2str(R1)])
disp(['���Լ����ݵ�R2Ϊ��', num2str(R2)])

%  MAE
mae1 = sum(abs(T_sim1' - T_train)) ./ M ;
mae2 = sum(abs(T_sim2' - T_test )) ./ N ;

disp(['ѵ�������ݵ�MAEΪ��', num2str(mae1)])
disp(['���Լ����ݵ�MAEΪ��', num2str(mae2)])

%  MBE
mbe1 = sum(T_sim1' - T_train) ./ M ;
mbe2 = sum(T_sim2' - T_test ) ./ N ;

disp(['ѵ�������ݵ�MBEΪ��', num2str(mbe1)])
disp(['���Լ����ݵ�MBEΪ��', num2str(mbe2)])

T_sim1 = T_sim1';
T_sim2 = T_sim2';
end