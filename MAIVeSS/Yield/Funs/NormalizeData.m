function res = NormalizeData(data, K)
%% Normalize data: can be normalized via different methods
K = length(data.Z);
for k = 1:K
    data.Z{k}.matrix = data.Z{k}.matrix / max(max(data.Z{k}.matrix));
end
data.Y = data.Y / (max(data.Y) - min(data.Y));
res = data;
end