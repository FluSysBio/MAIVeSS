function data = input_organization(X)
K = 3;
[n, d] = size(X);
data = cell([1 K]);
%% Main effects
 fprintf('Main Effects...\n');
 data{1}.matrix = sparse(X);
 data{1}.mapping = [];
 %% 2nd-order interactions
 fprintf('2nd-order Effects...\n');
 d2 = 0;
 indexmapping2 = zeros(1e2, 2);
 Z = zeros(n, 1e2);
 for i1 = 1:d
     if sum(X(:,i1)) == 0
         continue;
     end
     for i2 = i1+1:d
         interaction = X(:,i1).*X(:,i2);
         if sum(interaction) ~= 0
             d2 = d2 + 1;
             Z(:,d2) = interaction;
             indexmapping2(d2,:) = [i1,i2];
         end
     end
 end
 data{2}.matrix = sparse(Z);
 data{2}.mapping = indexmapping2;
 %% 3rd-order interactions
 fprintf('3rd-order Effects...\n');
 d3 = 0;
 indexmapping3 = zeros(1e2, 3);
 Z = zeros(n, 1e2);
 for i1 = 1:d
     if sum(X(:,i1)) == 0
         continue;
     end
     fprintf('Processing feature %d...\n', i1);
     for i2 = i1+1:d
         if sum(X(:,i1).*X(:,i2)) == 0
             continue;
         end
         for i3 = i2+1:d
             interaction = X(:,i1).*X(:,i2).*X(:,i3);
             if sum(interaction) ~= 0
                 d3 = d3 + 1;
                 Z(:,d3) = interaction;
                 indexmapping3(d3,:) = [i1,i2,i3];
             end
         end
     end
 end
 data{3}.mapping = indexmapping3;
 data{3}.matrix = sparse(Z);
 
%  % 4th-order interactions
%  d4 = 0;
%  indexmapping = zeros(1e3, 4);
%  Z = zeros(n, 1e3);
%  for i1 = 1:d
%      if sum(X(:,i1)) == 0 
%          continue;
%      end
%      for i2 = i1+1:d
%          if sum(X(:,i1).*X(:,i2)) == 0
%              continue;
%          end
%          fprintf('(%d,%d,...)\n',i1,i2);
%          for i3 = i2+1:d
%              if sum(X(:,i1).*X(:,i2).*X(:,i3)) == 0
%                  continue;
%              end
%              for i4 = i3+1:d
%                  interaction = X(:,i1).*X(:,i2).*X(:,i3).*X(:,i4);
%                  if sum(interaction) ~= 0
%                      d4 = d4 + 1;
%                      fprintf('Got one nnz, now d4 = %d\n',d4);
%                      Z(:,d4) = interaction;
%                      indexmapping(d4,:) = [i1,i2,i3,i4];
%                  end
%              end
%          end
%      end
%  end
%  data{4}.matrix = sparse(Z);
%  data{4}.mapping = indexmapping;
% % 5th-order interactions
% d5 = 0;
% indexmapping = zeros(1e5, 5);
% Z = zeros(n, 1e5);
% for i1 = 1:d
%     if sum(X(:,i1)) == 0
%         continue;
%     end
%     for i2 = i1+1:d
%         if sum(X(:,i1).*X(:,i2)) == 0
%             continue;
%         end
%         fprintf('(%d,%d,...)\n',i1,i2);
%         for i3 = i2+1:d
%             if sum(X(:,i1).*X(:,i2).*X(:,i3)) == 0
%                 continue;
%             end
%             for i4 = i3+1:d
%                 if sum(X(:,i1).*X(:,i2).*X(:,i3).*X(:,i4)) == 0
%                     continue;
%                 end
%                 for i5 = i4+1:d
%                     interaction = X(:,i1).*X(:,i2).*X(:,i3).*X(:,i4).*X(:,i5);
%                     if sum(interaction) ~= 0
%                         d5 = d5 + 1;
%                         fprintf('Got one nnz, now d5 = %d\n',d5);
%                         Z(:,d5) = interaction;
%                         indexmapping(d5,:) = [i1,i2,i3,i4,i5];
%                     end
%                 end
%             end
%         end
%     end
% end
% data{5}.matrix = sparse(Z);
% data{5}.mapping = indexmapping;


end