function folds = createCVforSVM(labls2use,parts)
folds = zeros(size(labls2use,1),5);
idxTestA = find(labls2use==1);
idxAfolds = reshape(idxTestA,length(idxTestA)/parts,parts);

idxTestB = find(labls2use==2);
idxBfolds = reshape(idxTestB,length(idxTestB)/parts,parts);

idxTest = [idxAfolds ; idxBfolds];
for i = 1:size(idxTest,2)
    folds(idxTest(:,i),i) = 1;
end
end
