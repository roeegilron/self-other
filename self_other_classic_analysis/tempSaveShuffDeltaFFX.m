if i ==1 % this is real data
    labels = labels;
else
    labels = shufMatrix(:,i-1);
end
realDataFFX = deltaData;
% compute the delta of the data by permuting the labels
% for each subject seperatly.
for i = 2:1001
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
meanShuffDeltaFFX(:,i-1) = mean(deltaData,1);
deltaData = []; 
end