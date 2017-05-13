function simtTtest()
% for i = 1:50
%  for j = 1:100
%  rawData(i,j) = rand-0.5;
%  end
% end
% save('rawNoise.mat','rawData');
load rawNoise.mat;
%% first row add 3 
% rawData(1:25,1:5) = rawData(1:25,1:5) + 3;
% rawData(26:end,1:5) = rawData(26:end,1:5) - 3;
% for i = 1:size(rawData,1)
%     rawData(i,:) = rawData(i,:)-mean(rawData(i,:));
% end
% for i = 1:size(rawData,1)
%     idx = randperm(100,1);
%     rawData(i,idx) = rawData(i,idx) + 3;
% end
%% non overlapping completly: 

% idxAdd = sort(repmat(1:50,1,2));
% for i = 1:size(rawData,1)
%     idxsUse = find(idxAdd==i);
%     rawData(i,idxsUse) = rawData(i,idxsUse) + 3;
%     % center subjtract mean from each row 
%     rawData(i,:) = rawData(i,:) - mean(rawData(i,:)); 
% end
%% randomize 
% 
% idxAdd = sort(repmat(1:50,1,2));
% for i = 1:size(rawData,1)
%     idxsUse = randperm(100,10);
%     rawData(i,idxsUse) = rawData(i,idxsUse) + 3;
%         center subjtract mean from each row 
%     rawData(i,:) = rawData(i,:) - mean(rawData(i,:)); 
% end

%% plot 
figure; 
subplot(2,1,1)
imagesc(rawData)
colorbar
title('sample simulation of delta A - B - non overlapping')
ylabel('subjects --> A-B')
xlabel('voxels - features')

realT = calcTmuniMeng(rawData);

for i = 1:1e3
    for j = 1 : 50
        tRand = rand;
        if rand<0.5
            shuffIdx(j,i) = 1;
        else
            shuffIdx(j,i) = -1;
        end
    end
end
% mtultiple yshhuflle martrx 
for i = 1:size(shuffIdx,2)
    shufMatrixToUse = shuffIdx(:,i);
    shufMatToMultiply = repmat(shufMatrixToUse,1,size(rawData,2));
    %     shufIdx = randperm(size(delta,2), floor(size(delta,2)/2));
    %     delta(shufIdx,:) = delta(shufIdx,:).*(-1);
    shuffT(i) = calcTmuniMeng(rawData.*shufMatToMultiply);
end
subplot(2,1,2); 
histogram(shuffT)
title(sprintf('1,000 sign flip shuffles on data - real T value is %2.2f',realT))
ylabel('count'); 
xlabel('multivariate T value')
end