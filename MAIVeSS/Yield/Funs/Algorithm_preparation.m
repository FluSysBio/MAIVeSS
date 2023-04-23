function [E,EIEE] = Algorithm_preparation(Z,K,d)
%% construct E{k} = (e1,e2,...,ed)' and H
E = construct_E(Z,K,d);
EIEE = cell([1 K]);
for k = 2:K
    EIEE{k} = E{k}/(eye(size(E{k},2)) + E{k}'*E{k});
end
for k = 1:K
    E{k} = sparse(E{k});
end

end

function E = construct_E(Z,K,d)
E = cell([1 K]); % E{1} will not be used
for k = 2:K
    for i = 1:d
        mapping = Z{k}.mapping;
        len = size(Z{k}.mapping,1);
        e = zeros([len 1]);
        %% i may appear in each column
        for column = 1:k
            position = mapping(:,column) == i; 
            e(position) = 1;
        end
        E{k}(:,i) = e;
    end
end


end