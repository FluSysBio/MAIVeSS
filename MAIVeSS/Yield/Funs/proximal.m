function Theta_bar = proximal(v,E,EIEE,tau_t,lambda,K,d_vec)
%% The ADMM algorithm (Now it does not converge. Do not know why)
%%
Max_iter_num = 5;
%%
d = d_vec(1);
eps = 1e-5;
Rho = 0.1;
%% setting
Theta_bar = cell([1 K]);
old_Theta_bar = cell([1 K]);
for k = 1:K
    Theta_bar{k} = zeros([d_vec(k) 1]);
    old_Theta_bar{k} = zeros([d_vec(k) 1]);
end
P = Theta_bar;
A = P;
Q = zeros([K-1 d]);
B = Q;
c = cell([1 K]); %% c{1} will not be used
v_check = cell([1 K]);
for k = 1:K
    v_check{k} = abs(v{k}) - lambda(k)/tau_t;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for ADMM_iter = 1:Max_iter_num
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Solve Theta_bar (Theta_bar must be nonnegative)
    for k = 1:K
        Theta_bar{k} = max(0, (tau_t*v_check{k} + Rho*P{k} + A{k})/(tau_t + Rho) );
    end
    %% Solve P{2} to P{K}
    % Update c
    for k = 2:K
        sum_d = 0;
        for i = 1:d
            sum_d = sum_d + ( B(k-1,i)/Rho + Q(k-1,i) )*E{k}(:,i);
        end
        c{k} = Theta_bar{k} - A{k}/Rho + sum_d;
    end
    % Update P
    for k = 2:K
        P{k} = c{k} - EIEE{k}*(E{k}'*c{k});
    end
    %% Solve Q and Theta_bar{1}
    % setting
    varTheta = zeros([K-1 d]);
    for i = 1:d
        for k = 2:K
            varTheta(k-1,i) = E{k}(:,i)'*P{k};
        end
    end
    varTheta_check = zeros([K-1 d]);
    for i = 1:d
        varTheta_check(:,i) = varTheta(:,i) - 1/Rho*B(:,i);
    end
    % d 'sequence' subproblems
    for i = 1:d
        u = [Theta_bar{1}(i) - A{1}(i)/Rho, varTheta_check(:,i)']'; % u is of length K
        s = Sequence_matlab(u,'non-increasing'); % the Sequence_matlab function does not take the weight omega now, so Rho must set to 1
        P{1}(i) = s(1);
        Q(:,i) = s(2:end);
    end
    %% Update Lagrangian parameters A and B
    for k = 1:K
        A{k} = A{k} + Rho*(P{k} - Theta_bar{k});
    end
    B = B + Rho*(Q - varTheta_check);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% check termination
    Err = 0;
    for k = 1:K
        Err = Err + norm( old_Theta_bar{k} - Theta_bar{k}, 2 );
    end
%     fprintf('Err = %f\n', Err);
    if Err < eps
        break;
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end


end


