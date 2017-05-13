function [rfxMatrix, lableMatrix] = createRFXdata(rawData,numShuffels,labels)
%% create mean data
dataA  = squeeze(mean(rawData(labels==1,:,:),1))';
dataB  = squeeze(mean(rawData(labels==2,:,:),1))';
rawDelta = dataA - dataB;
labelsA = ones(size(dataA,1),1) ;
labelsB = ones(size(dataB,1),1).*2 ;
meanlabels = [labelsA ;  labelsB];
meanData = [dataA ; dataB];
%% choose how to do the shuffling
options = 3; % 3 = use delta and sign flipping 
%% create shuffle and real data in a big matrix
for i = 1:numShuffels + 1
    if i ==1 % don't shuffle
        rfxMatrix(:,:,i) = meanData(meanlabels==1,:) -  meanData(meanlabels==2,:);
        lableMatrix(:,i) = meanlabels;
    else
        labels2ShuffA = labelsA;
        labels2ShuffB = labelsB;
        %% option 1 creates non uniform number of subs flipped
        switch  options
            case 1
                for k = 1:length(labelsA) % decide if you will flip yes / no
                    if rand < 0.5
                        labels2ShuffA(k) = 2;
                        labels2ShuffB(k) = 1;
                    else
                    end
                end
                %% option 2 creats uniform distributio of subs flipped
            case 2
                numsubs = length(labelsA);
                numsubstoflip = randperm(numsubs,1);
                randsubidxs = randperm(numsubs,numsubstoflip);
                labels2ShuffA(randsubidxs) = 2;
                labels2ShuffB(randsubidxs) = 1;
            case 3
                randnums = [];
                randnums = rand(size(rawDelta,1),1); 
                signflips(randnums < 0.5) = -1;
                signflips(randnums > 0.5) = 1;
                tomultip = repmat(signflips',1,size(rawDelta,2));
                oneShuf = rawDelta .* tomultip;
        end
        shuffLabels = [labels2ShuffA ; labels2ShuffB];
        lableMatrix(:,i) = shuffLabels;
        rfxMatrix(:,:,i) = oneShuf;
    end
    fprintf('rfx shuffle %d out of %d\n',i,numShuffels);
end

end
