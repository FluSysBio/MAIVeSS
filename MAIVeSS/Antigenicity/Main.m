clear;
clc;
close all;

%% add path
addpath('Funs')
addpath('Data')
load TrainingData.mat


%% run Multi-task Sparse Group Lasso
groups = {[1:86],[87:90]};
GW = [length(groups{1}), length(groups{2})];
GW = sqrt(GW);


lambda1 = 1; % parameter for the multi-task (l2) term default 1
lambda2 = 0.5; % parameter for the group lasso (l2) term default 0.5
lambda3 = 0.01; % parameter for sparse l1 norm default 0.01


%%  Learning
for i = 1:length(lambda1)
    for j = 1:length(lambda2)
        for p = 1:length(lambda3)
            Dtimes=datetime('now','TimeZone','local','Format','d-MMM-y HH:mm:ss Z');
            display(Dtimes)
            disp([' Date and time is ' char(Dtimes)] ); 
            [Final_W_MTL_sgl, Tar{i}{j,p}] = MTL_GGSL(Xmtl, Ymtl, lambda1(i), lambda2(j),lambda3(p), groups, GW);
        end
    end
end
%%  RMSE
[Final_RMSE_sgl, Final_Relative_Err_sgl] = Main_Test(Final_W_MTL_sgl, Xmtl, Ymtl);
RMSE = mean(Final_RMSE_sgl);
fprintf('RMSE = %f\n', RMSE);

Final_W = Final_W_MTL_sgl;
pre_y1 = Xmtl{1}*Final_W(:,1);
pre_y2 = Xmtl{2}*Final_W(:,2);
pre_y3 = Xmtl{3}*Final_W(:,3);
pre_y4 = Xmtl{4}*Final_W(:,4);
pre_y5 = Xmtl{5}*Final_W(:,5);
pre_y6 = Xmtl{6}*Final_W(:,6);
pre_y7 = Xmtl{7}*Final_W(:,7);
pre_y8 = Xmtl{8}*Final_W(:,8);
pre_y{1} = pre_y1;
pre_y{2} = pre_y2;
pre_y{3} = pre_y3;
pre_y{4} = pre_y4;
pre_y{5} = pre_y5;
pre_y{6} = pre_y6;
pre_y{7} = pre_y7;
pre_y{8} = pre_y8;
            
for iii = 1:8
    acc(:,iii) = (nnz( ( Ymtl{iii} >= 2 ) .* ( pre_y{iii} >= 2 ) ) + nnz( ( Ymtl{iii} < 2 ) .* ( pre_y{iii} < 2 ) ) ) / length( pre_y{iii} );
    sen(:,iii) = sum( ( Ymtl{iii} >= 2 ) .* ( pre_y{iii} >= 2 ) ) / nnz( Ymtl{iii} >= 2 );
    spe(:,iii) = sum( ( Ymtl{iii} < 2 ) .* ( pre_y{iii} < 2 ) ) / nnz( Ymtl{iii} < 2 );
end
ACC = mean(acc);
fprintf('ACC = %f\n', ACC);