function [W, Tar] = MTL_GGSL(X, Y, lambda1, lambda2, lambda3, groups, weights)

% Solve MTL sparse group lasso via ADMM
MAX_ITER = 500;
rho = 1.5;

m = length(Y);
d = size(X{1}, 2);

% initial W, Q and U
W = zeros(d,m);
Q = zeros(d,m);
U = zeros(d,m);
Tar = [];

for iter = 1:MAX_ITER
    
    %% update W (for each task)
    for i = 1:m 
        I = eye(d);
        
        F = X{i}'*X{i} + rho* I;
        B = X{i}'*Y{i} - rho*U(:,i) + rho*Q(:,i);
        
        W(:,i) = F^-1 * B;
    end
    
    %% update Q 
    % in order to update Q, we should update O, PAI, and R first
    n = size(W, 1);
    PAI = zeros(d,m);
    R = zeros(d,m);
    % update O
    O = W + U/rho;
    % update PAI
    for k = 1:n
        if(norm(O(k,:),2) == 0)
            PAI(k,:) = max((norm(O(k,:),2)-lambda1/rho),0)*O(k,:);
        else   
            PAI(k,:) = max((norm(O(k,:),2)-lambda1/rho),0)*O(k,:)/norm(O(k,:),2);
        end
    end
    % update R
    Gp = cell(1); 
    Wg = weights;
    for ii = 1:length(groups)
        index_g = groups{ii};

        tmp_gp = zeros(1,size(R,2));
        for kk = index_g
            tmp_gp = tmp_gp + PAI(kk,:).^2;
        end
        Gp{ii} = sqrt(tmp_gp);
    end

    for ii = 1:length(groups)
        index_g = groups{ii};
        AlternativeGp = Gp{ii};         
        AlternativeGp(find(AlternativeGp == 0)) = 1;    % in case of zeros in Gp(ii)
        for k = 1:m
            R(index_g,k) = PAI(index_g,k).*max((Gp{ii}(k)-lambda2*Wg(ii)/rho),0)./AlternativeGp(k);
        end
    end
    
    % update Q
    Gr = cell(1); 
    Wg = weights;
    for ii = 1:length(groups)
        index_r = groups{ii};

        tmp_gr = zeros(1,size(Q,2));
        for kk = index_r
            tmp_gr = tmp_gr + R(kk,:).^2;
        end
        Gr{ii} = sqrt(tmp_gr);
    end

    for ii = 1:length(groups)
        index_r = groups{ii};
        AlternativeGr = Gr{ii};         
        AlternativeGr(find(AlternativeGr == 0)) = 1;    % in case of zeros in Gr(ii)
        for k = 1:m
            Q(index_r,k) = sign(R(index_r,k)) .* max(abs(R(index_r,k)) - lambda3*Wg(ii)/rho, 0);
        end
    end
    
    %% update U
    U = U + rho*(W - Q);
    
    %% Print
    
    Loss = 0;
    for j = 1:m
        Loss = Loss + norm(X{j}*W(:, j) - Y{j},2);
    end
    
    L1 = 0;

    for j = 1:m
        L1 = L1 + norm(W(:, j),1);
    end
    L1 = L1*lambda3;
   
    L2 = 0;   
    for ii = 1:length(groups)
        index_g = groups{ii};

        tmp_gp = 0;
        for kk = index_g
            tmp_gp = tmp_gp + norm(W(kk,:),2);
        end
        tmp_gp = sqrt(tmp_gp);
        L2 = L2 + tmp_gp*sqrt(length(groups{ii}));
    end
    L2 = L2*lambda2;
    
    L_mtl = 0;
    for j = 1:d
        L_mtl = L_mtl + norm(W(j, :),2);
    end
    L_mtl = L_mtl*lambda1;
    
    Obj_fun = Loss + L1 + L2 + L_mtl;
    
    gradient_f = zeros([d m]);
    for i = 1:m
        gradient_f(:,i) = X{i}'*( X{i}*W(:,i) - Y{i} );
    end
    
    Tar = [Tar Obj_fun];
    
    Grad_Norm = norm(gradient_f, 'fro');
    if mod(iter, 100) == 0
        fprintf('Iter = %d/%d, Grad norm = %f, Target Function = %f (Loss = %f, L1 = %f, L2 = %f,Lg = %f)\n', iter, MAX_ITER, Grad_Norm,Obj_fun,Loss,L1,L2,L_mtl);
    end 
    
end


end
