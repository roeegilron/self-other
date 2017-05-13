function dataDelta = getDeltaOfDataFFX(data,labels,shufMatrix)
%% FFX shuffling 
%  The main idea behind FFX shuffle is that there is no effect 
%  within each subject. Therefore, this shuffle randomizes both 
%  subject and label by just randomizing the rows of the data.
%  I will keep the labels the same. 
%  output: 
%    this code retursn the shuffeled idxs of rows in data
outData = data(shufMatrix,:);
% idxA = find(labels == 1);
% idxB = find(labels == 2);

dataDelta = outData((labels == 1), :) - outData((labels ==2) , :);

end