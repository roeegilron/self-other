function [X, partition] = KfoldCVBalance(X, y, k)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Pree Thiengburanathum
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Description:
% To ensure that the training, testing, and validating dataset have similar
% proportions of classes (e.g., 20 classes). This stratified sampling
% technique provided the analyst with more control over the sampling process.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input:
% X - dataset
% k - number of fold
% classData - the class data
%
% Output:
% X - new dataset
% partition - fold index
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
n = size(X, 1);
partition = repmat(0, n, 1);
% shuffle the dataset
[~, idx] = sort(rand(1, n));
X = X(idx, :);
y = y(idx);
% find the unique class
group = unique(y);
nGroup = numel(group);
% find min max number of sample per class
nmax = 0;
for i=1:nGroup
    idx = find(y == group(i));
    ni = length(idx);
    nmax = max(nmax, ni);
end
% create fold indices
foldIndices = zeros(nGroup, nmax);
for i=1:nGroup
    idx = find(y == group(i));
    foldIndices(i, 1:numel(idx)) = idx;
end
% compute fold size for each fold
foldSize = zeros(nGroup, 1);
for i=1:nGroup
    % find the number of element of the class
    numElement = numel(find(foldIndices(i,:) ~= 0));
    % calculate number of element for each fold
    foldSize(i) = floor(numElement/k);
end
ptr = ones(nGroup, 1);
for i=1:k
    for j=1:nGroup
        idx =  foldIndices(j, (ptr(j): (ptr(j)+foldSize(j)) ));
        if(idx(end) == 0)
           idx = idx(1:end-1);
        end
        partition (idx) = i;
        ptr(j) = ptr(j)+foldSize(j);
    end
end
% dump the rest of index to the last fold
idx = find(partition == 0);
partition(idx) = k;
data = [X partition];
% check class balance for each fold
for i=1:k
    idx = find(data(:, 2) == i);
    fold = X(idx);
    disp(['fold# ', int2str(i), ' has ', int2str( numel(fold) ) ]);
    for j=1:nGroup
        idx = find(fold == group(j));
        percentage = (numel(idx)/numel(fold)) * 100;
        disp(['class# ', int2str(j), ' = ', num2str(percentage), '%']);
 
 
    end
    disp(' ');
end
end % end function