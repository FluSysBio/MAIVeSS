function para = Run_GHSM(TrainZ, TrainY, TestZ, TestY, K)
%% Run
lambda = 1e-3;
decay = 2;
d = size(TrainZ{1}.matrix, 2);
Max_GISTIter = 200;
[E, EIEE] = Algorithm_preparation(TrainZ,K,d(1));
tic;
Theta = GHSM(TrainZ,TrainY,lambda,decay,K,E,EIEE,Max_GISTIter);
runtime = toc;
%% Test Error
num_test = length(TestY);
Pre_Y = 0;
for k = 1:K
    Pre_Y = Pre_Y + TestZ{k}.matrix*Theta{k};
end
RMSE = sqrt(norm(TestY - Pre_Y, 2)^2 / num_test);
para.Theta = Theta;
para.RMSE = RMSE;
para.runtime = runtime;
end