function deltaData = getDeltaDataOneBigMatrixNoAverageTrials(data,labels,i)
% compute the delta of the data by permuting the labels
% for each subject seperatly.
% data is of size (trials,voxels,subjects)
deltaData = [];
for k = 1:size(data,3) % loop on subjects 
    if i == 1 % don't permuse it if its the first shuffle
        shufflabels = labels;
    else
        shufflabels = labels(randperm(length(labels)));
    end
    a = data(shufflabels==1,:,k); % get a labels
    b = data(shufflabels==2,:,k); % get b labels 
    deltaDataOneSub = a-b;
    deltaData = [deltaData ; deltaDataOneSub]; % get one big delta matrix
end


end
