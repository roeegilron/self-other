function c = balanceDataInFolds(labelsin,foldin)
% this function creates stratified k folds 
% but ensures that in each fold equal number of each class
% is represnted 
% it randomly discards a portion of each classs in each fold 
% this insures balanced class representation in each fold 
unqfolds = unique(foldin); 
for i = 1:length(unqfolds) % loop on unique folds 
    idxfold = foldin==unqfolds(i);
    labfold = labelsin(foldin==unqfolds(i)); % get labels of fold 
    unqlab = unique(labfold);
    % find out how many labels of each class in the fold 
    for j = 1:length(unqlab)
        labcount(j) = sum(labfold==unqlab(j));
    end
    minclass = min(labcount);
    % get indices for labels in each class 
    foldkeep = zeros(length(idxfold),1);
    for j = 1:length(unqlab)
        idxunq = unqlab(j) == labelsin;
        idxOfLabInFold = find(idxfold &  idxunq == 1);
        idxkeep = idxOfLabInFold(randperm(length(idxOfLabInFold),minclass));
        foldkeep(idxkeep) = 1; 
    end
    c(i).test = logical(foldkeep); 
end
for i = 1:length(c) % set up train sets (everything that isn't test 
    idxgo = setdiff(1:length(c),i);
    temp = zeros(length(idxfold),1);
    for j = 1:length(idxgo)
        temp(c(idxgo(j)).test) = 1;
    end
    c(i).train = logical(temp);
end

end
