clear;
clc;
close all;

addpath('Data');
addpath('Funcs');

[pima, Mapping] = GetPIMA();

%% Antigenicity prediction
load Antigenicity.mat

N = length(base_seq); % three vaccine repeated at last 11427 = 11424+3
w = mean(Final_W_MTL_sgl,2);

D = zeros(N);
for i = 1:N
    fprintf('i = %d/%d\n', i, N);
    for j = i+1:N
        Seq_A = base_seq{i};
        Seq_B = base_seq{j};
        x = GetPairDiffX(length(Seq_A), Seq_A, Seq_B, pima);
        D(i, j) = x * 0.4* w + x * (0 * Final_W_MTL_sgl(:,7) + 0.6 * Final_W_MTL_sgl(:,8));
        
        if D(i, j) <= 0
            % In case there are duplicated viruses or negative predictions
            D(i, j) = 1e-3;
        end
        D(j, i) = D(i, j);
    end
end

%% Yield prediction
load Yield.mat
NN = length(base_seqY);
[m2,n2] = size(indexmapping2);
[m3,n3] = size(indexmapping3);
% cell prediction
for i = 1:NN
    fprintf('i = %d/%d\n', i, NN);
    for j = 1
        Seq_A = base_seqY{i};
        Seq_B = base_seqY{j};
        x = GetPairDiffX(length(Seq_A), Seq_A, Seq_B, pima);
        for p = 1:m2
            inter2(:,p) = x(:,indexmapping2(p,1)) .* x(:,indexmapping2(p,2));
        end
        for pp = 1:m3
            inter3(:,pp) = x(:,indexmapping3(pp,1)) .* x(:,indexmapping3(pp,2)) .* x(:,indexmapping3(pp,3));
        end
        XCell(i,1) = x * cw{1} + inter2 * cw{2} + inter3 * cw{3};
    end
end
% egg prediction
for i = 1:NN
    fprintf('i = %d/%d\n', i, NN);
    for j = 1
        Seq_A = base_seqY{i};
        Seq_B = base_seqY{j};
        x = GetPairDiffX(length(Seq_A), Seq_A, Seq_B, pima);
        for p = 1:m2
            inter2(:,p) = x(:,indexmapping2(p,1)) .* x(:,indexmapping2(p,2));
        end
        for pp = 1:m3
            inter3(:,pp) = x(:,indexmapping3(pp,1)) .* x(:,indexmapping3(pp,2)) .* x(:,indexmapping3(pp,3));
        end
        YEgg(i,1) = x * ew{1} + inter2 * ew{2} + inter3 * ew{3};
    end
end