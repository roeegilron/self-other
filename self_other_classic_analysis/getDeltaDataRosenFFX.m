function  deltaData = getDeltaDataRosenFFX(data,labels,shufMatrix,i)
% this function gets the delta of the data for the rosen FFX.
% This is basically directional FFX.
% the null assumption here is that htere is no signal within each subject
% so you get rid of the signal by shuffling each subject's labels then
% taking hte mean
if i ==1 % this is real data
    labels = labels;
else
    labels = shufMatrix(:,i-1);
end

% compute the delta of the data by permuting the labels
% for each subject seperatly.
for k = 1:size(data,3)
    if i == 1
        shufflabels = labels;
    else
        shufflabels = labels(randperm(length(labels)));
    end
    a = squeeze(mean(data(shufflabels==1,:,k),1));
    b = squeeze(mean(data(shufflabels==2,:,k),1));
    deltaData(k,:) = a-b;
end
end