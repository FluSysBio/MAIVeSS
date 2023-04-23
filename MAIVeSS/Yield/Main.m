clear;
clc;
close all;

addpath('Funs');
addpath('Data');

load TrainingData.mat

data.Z = input_organization(Xtrain(:,1:84));
data.Y = Ytrain(:,1); % first column for cell and second column for egg

%% GHSM
Lambda = 1e-4;
decay = 10;
K = 3;
d = zeros([1 K]);
for k = 1:K
    d(k) = size(data.Z{k}.matrix, 2);
end

Num_sample = length(data.Y);
%% Run GHSM
tic;
[E,EIEE] = Algorithm_preparation(data.Z,K,d(1));
Max_GISTIter = 1000;
for i = 1:length(Lambda)
    lambda = Lambda(i);
Theta = GHSM(data.Z,data.Y,lambda,decay,K,E,EIEE,Max_GISTIter); 
runtime = toc;
%% Training Error
Pre_Y = 0;
for k = 1:K
    Pre_Y = Pre_Y + data.Z{k}.matrix*Theta{k};
end
RMSE(i) = sqrt(norm(data.Y - Pre_Y, 2)^2 / Num_sample);
fprintf('RMSE = %f, runtime = %f\n', RMSE(i), runtime);
end