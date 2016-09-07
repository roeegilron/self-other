function outlabels = shufflelabelsWithinFold(rawlabels,fold)
outlabels = zeros(length(rawlabels),1);
unqfolds = unique(fold);
for i = 1:length(unqfolds)
    idxfold = fold == unqfolds(i);
    labtoshuf = rawlabels(idxfold);
    shuflabel = labtoshuf(randperm(length(labtoshuf)));
    outlabels(idxfold,1) = shuflabel;
end
end