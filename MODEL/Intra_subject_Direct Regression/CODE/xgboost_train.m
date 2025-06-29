function model = xgboost_train(p_train, t_train, params, max_num_iters)

%%% Function inputs:
% p_train:        matrix of inputs for the training set
% t_train:        vetor of labels/values for the test set
% params :        structure of learning parameters
% max_num_iters: max number of iterations for learning

%%% Function output:
% model: a structure containing:
%     iters_optimal; % number of iterations performs by xgboost (final model)
%     h_booster_ptr; % pointer to the final model
%     params;        % model parameters (just for info)
%     missing;       % value considered "missing"

%%  
loadlibrary('xgboost')

%% 
missing = single(NaN);          
iters_optimal = max_num_iters;  

%%  
if isempty(params)
    params.booster           = 'gbtree';
    % params.objective         = 'binary:logistic';
    params.objective         = 'reg:linear';
    params.max_depth         = 5;
    params.eta               = 0.1;
    params.min_child_weight  = 1;
    params.subsample         = 0.9;
    params.colsample_bytree  = 1;
    params.num_parallel_tree = 1;
end

%%  
param_fields = fields(params);
for i = 1 : length(param_fields)
    eval(['params.' param_fields{i} ' = num2str(params.' param_fields{i} ');'])
end

%%  
rows = uint64(size(p_train, 1));  
cols = uint64(size(p_train, 2));  
p_train = p_train';

%% 
p_train_ptr = libpointer('singlePtr', single(p_train));
t_train_ptr = libpointer('singlePtr', single(t_train));

h_train_ptr = libpointer;
h_train_ptr_ptr = libpointer('voidPtrPtr', h_train_ptr);

%% 
calllib('xgboost', 'XGDMatrixCreateFromMat', p_train_ptr, rows, cols, missing, h_train_ptr_ptr);

%% 
labelStr = 'label';
calllib('xgboost', 'XGDMatrixSetFloatInfo', h_train_ptr, labelStr, t_train_ptr, rows);

%%  
h_booster_ptr = libpointer;
h_booster_ptr_ptr = libpointer('voidPtrPtr', h_booster_ptr);
calllib('xgboost', 'XGBoosterCreate', h_train_ptr_ptr, uint64(1), h_booster_ptr_ptr);

for i = 1 : length(param_fields)
    eval(['calllib(''xgboost'', ''XGBoosterSetParam'', h_booster_ptr, ''' param_fields{i} ''', ''' eval(['params.' param_fields{i}]) ''');'])
end

%%  
for iter = 0 : iters_optimal
    calllib('xgboost', 'XGBoosterUpdateOneIter', h_booster_ptr, int32(iter), h_train_ptr);
end

%% 
model                = struct;
model.iters_optimal  = iters_optimal;  
model.h_booster_ptr  = h_booster_ptr;  
model.params         = params;         
model.missing        = missing;       
