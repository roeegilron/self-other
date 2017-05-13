function folds = getFolds(labels,subjects)
getRandOrder = randperm(max(unique(subjects))); 
unrolledFolds = [];
for i = 1:length(getRandOrder)
    unrolledFolds = [unrolledFolds ;find(getRandOrder(i) == subjects) ];
end
folds = reshape(unrolledFolds,[36,6]); 


end

