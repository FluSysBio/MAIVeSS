function Theta = GHSM(Z,y,Lamb,decay,K,E,EIEE,Max_GISTIter)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
tau_t = 1e0;
%%
eps = 1e-10;
Sigma = 1e-5;
eta = 2;
tau_min = 1e-20;
tau_max = 1e20;
n = size(Z{1}.matrix, 1);
d = zeros([1 K]);
for k = 1:K
    d(k) = size(Z{k}.matrix,2);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
lambda = zeros([1 K]);
lambda(1) = Lamb;
if K ~= 1
    for k = 2:K
        lambda(k) = lambda(k-1)*decay^(-k+1);
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialize Theta
Theta = cell([1 K]);
Theta_new = cell([1 K]);
for k = 1:K
    Theta{k} = zeros([d(k) 1]);
end
v = cell([1 K]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for APG_iter = 1:Max_GISTIter
    %% find a small L_k
    tau_t = min(max(tau_t,tau_min),tau_max); % initial L_k \in [L_min, L_max]
    while true
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% compute gradient
        sum_K = 0;
        for k = 1:K
            sum_K = sum_K + Z{k}.matrix*Theta{k};
        end
        for k = 1:K
            L_Gradient = Z{k}.matrix'*(sum_K - y) / n;
            v{k} = Theta{k} - 1/tau_t*L_Gradient;
        end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% Solve proximal operator
        Theta_bar = proximal(v,E,EIEE,tau_t,lambda,K,d);
        for k = 1:K
            Theta_new{k} = sign(v{k}).*Theta_bar{k};
        end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% check line search
        [val_new, val, res] = line_search(Z,y,Theta_new,Theta,K,lambda,tau_t,Sigma);
        if res == 1
            break;
        else
            fprintf('Searching tau_t (%f)...\n',tau_t);
            tau_t = tau_t * eta;
        end
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% check termination
    fprintf('GISTA_iter = %d, obj = %f\n', APG_iter, val_new);
    if val - val_new < eps
        fprintf('break at GISTA_iter = %d\n', APG_iter);
        break;
    end
    Theta = Theta_new;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
fprintf('Maximum GISTA_iter achieved.\n');

end

function [val_new, val, res] = line_search(Z,y,Theta_new,Theta,K,lambda,tau_k,Sigma)
val_new = obj_val(Z,y,Theta_new,lambda,K);
val = obj_val(Z,y,Theta,lambda,K);
%%
sum_diff = 0;
for k = 1:K
    sum_diff = sum_diff + norm(Theta_new{k} - Theta{k}, 2)^2;
end
if val_new <= val - Sigma*tau_k/2*sum_diff;
    res = 1;
else
    res = 0;
end

end

function res = obj_val(Z,y,Theta,lambda,K)
n = length(y);
sum_K = 0;
for k = 1:K
    sum_K = sum_K + Z{k}.matrix*Theta{k};
end
loss = 0.5*norm(y-sum_K,2)^2 / n;
regularizer = 0;
for k = 1:K
    regularizer = regularizer + lambda(k)*norm(Theta{k},1);
end
res = loss + regularizer;


end









