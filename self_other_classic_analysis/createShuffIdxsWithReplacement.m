function shuffIdx = createShuffIdxsWithReplacement(data,labels,params) 
if ~params.shuffleData
    shuffIdx = []; 
else
    %% generate a shuffle matrix 
    numShuffels = params.numShuffels;
    subjects = sum(labels==1); % assume equal number of labels 1 and 2 
    for i = 1:numShuffels
        for j = 1 : subjects
            tRand = rand;
            if rand<0.5
                shuffIdx(j,i,1) = 1;
            else 
                shuffIdx(j,i,1) = -1;
            end
            shuffIdx(j,i,2) = randperm(subjects,1);
        end
    end
end
end

