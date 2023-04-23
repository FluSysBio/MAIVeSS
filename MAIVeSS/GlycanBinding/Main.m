clear;
clc;
close all;

%% add path
addpath('Funs')
addpath('Data')

load('TrainingData.mat')

Y_train = HBT; % HBT=high both, HCT=high cell, HET=high egg, LBT=low both
[m,n] = size(Y_train);

for i = 1:n
    Xmtl{i} = X_train;
    Ymtl{i} = Y_train(:,i);
end

Xtest = Xmtl;
Ytest = Ymtl;

%% parameter setting
groups = {[1:3],[4:11],[12:27]};
GW = [length(groups{1}), length(groups{2}), length(groups{3})];
GW = sqrt(GW);

lambda1 = 1; % parameter for the multi-task (l2) term default 1
lambda2 = 0.5; % parameter for the group lasso (l2) term default 0.5
lambda3 = 0.01; % parameter for sparse l1 norm default 0.01

%%  Learning
[Final_W_MTL_sgl, Tar] = MTL_GGSL(Xmtl, Ymtl, lambda1, lambda2, lambda3, groups, GW);

%%  RMSE
[Final_RMSE_sgl, Final_Relative_Err_sgl] = Main_Test(Final_W_MTL_sgl, Xtest, Ytest);
RMSE = mean(Final_RMSE_sgl);
fprintf('RMSE = %f\n', RMSE);