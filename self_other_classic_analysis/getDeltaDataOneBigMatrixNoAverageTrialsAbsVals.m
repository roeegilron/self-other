function deltaData = getDeltaDataOneBigMatrixNoAverageTrialsAbsVals(data,labels,i)
% This fuction computes the delta of the data by permuting the labels
% for each subject seperatly. It then takes the norm.
% data is of size (trials,voxels,subjects)
for k = 1:size(data,3) % loop on subjects 
    if i == 1 % don't shuffle labels if its the first shuffle 
        shufflabels = labels;
    else
        shufflabels = labels(randperm(length(labels)));
    end
    a = data(shufflabels==1,:,k); % find a labels 
    b = data(shufflabels==2,:,k); % find b labels 
    deltaDataOneSub = a-b;
    % Take the mean of norms for this subject 
    meanNormPerSub = mean(sqrt((deltaDataOneSub.^2)),1);
    deltaData(k,:) = meanNormPerSub;
end


end
