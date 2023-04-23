function x = Sequence_matlab(u, constraint_order)
if strcmp(constraint_order,'non-decreasing') == 1
    % do nothing
elseif strcmp(constraint_order,'non-increasing') == 1
    l = length(u);
    tmp = zeros([1 l]);
    for i = 1:l
        tmp(l-i+1) = u(i);
    end
    u = tmp;
else
    error('The constraint order must be non-decreasing or non-increasing!');
end
%% return a non-decreasing sequence
n = length(u);
non_increasing_interval = cell([1 1]);
t = 0;
begin_idx = 1;
for i = 2:n
    if u(i) <= u(i-1)
        if i~=n
            continue;
        else
            end_idx = i;
            t = t + 1;
            non_increasing_interval{t}.sequence = u(begin_idx:end_idx);
            non_increasing_interval{t}.optimal = mean(non_increasing_interval{t}.sequence);
            non_increasing_interval{t}.size = length(non_increasing_interval{t}.sequence);
        end        
    else
        end_idx = i-1;
        t = t + 1;
        non_increasing_interval{t}.sequence = u(begin_idx:end_idx);
        non_increasing_interval{t}.optimal = mean(non_increasing_interval{t}.sequence);
        non_increasing_interval{t}.size = length(non_increasing_interval{t}.sequence);
        begin_idx = i;
        if i == n
            end_idx = i;
            t = t + 1;
            non_increasing_interval{t}.sequence = u(begin_idx:end_idx);
            non_increasing_interval{t}.optimal = mean(non_increasing_interval{t}.sequence);
            non_increasing_interval{t}.size = length(non_increasing_interval{t}.sequence);
        end
    end
end
L = t;
Stack = cell([1 L]);
t = 1;
Stack{t} = non_increasing_interval{1};
for i = 2:L
    if Stack{t}.optimal <= non_increasing_interval{i}.optimal
        t = t+1;
        Stack{t} = non_increasing_interval{i};
        continue;
    else
        Stack{t} = Combine(Stack{t}, non_increasing_interval{i});
        while 1
            %% check the top-2
            if t == 1
                break;
            else
                if Stack{t-1}.optimal > Stack{t}.optimal
                    Stack{t-1} = Combine(Stack{t-1}, Stack{t});
                    t = t-1;
                    continue;
                else
                    break;
                end
            end
        end
    end
end
%%
x = zeros([1 n]);
k = 1;
for i = 1:t
    for j = 1:Stack{i}.size
        x(k) = Stack{i}.optimal;
        k = k+1;
    end
end
%%
if strcmp(constraint_order,'non-decreasing') == 1
    % do nothing
else
    tmp = zeros([1 l]);
    for i = 1:l
        tmp(l-i+1) = x(i);
    end
    x = tmp;
end


end

function res = Combine(Seq_a,Seq_b)
new_optimal = (Seq_a.optimal*Seq_a.size + Seq_b.optimal*Seq_b.size)/(Seq_a.size + Seq_b.size);
res.optimal = new_optimal;
res.sequence = [Seq_a.sequence, Seq_b.sequence];
res.size = Seq_a.size + Seq_b.size;
end







