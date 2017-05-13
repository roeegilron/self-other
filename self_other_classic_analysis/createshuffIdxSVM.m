function shuffIdxSVM = createshuffIdxSVM(labels,shuffIdx)
shuffIdxSVM = zeros(size(labels,1),size(shuffIdx,2));
% double shuffIdxs so easier to transforsm
dbShuffIdx = [];
for i = 1:size(shuffIdx,1)
    cl = shuffIdx(i,:);
    cl2 = [cl ; cl];
    dbShuffIdx = [dbShuffIdx; cl2];
end
% loop on db ShuffIdx and create shuffidxs of albes fro svm
for i = 1:size(dbShuffIdx,2)
    tmpLabels = labels;
    idxFlip = find(dbShuffIdx(:,i)==(-1));
    toFlip = tmpLabels(idxFlip);
    flipped = zeros(size(toFlip));
    flipped(toFlip==1) = 2;
    flipped(toFlip==2) = 1;
    tmpLabels(idxFlip) = flipped;
    shuffIdxSVM(:,i) = tmpLabels;
end