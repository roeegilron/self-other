function dataDelta = getDeltaOfData(data,labels,params)
idxA = find(labels == 1);
idxB = find(labels == 2);

dataDelta = data(idxA , :) - data(idxB , :);

end
