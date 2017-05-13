function testOldTvsNewT()
rootDirOriginalData = ...
    'F:\vocalDataSet\processedData\matFilesProcessedData\stats_normalized_sep_beta';
load(fullfile(rootDirOriginalData,'allSubsBetas.mat'),...
    'mask','locations','allSubsData','labels');

idx = knnsearch(locations, locations, 'K', 27);

randsubs = [45 145];
rng(1); 
randidxs = randperm(size(idx,1),2e3);
for isb = 1:length(randsubs);
    dataonesub = allSubsData(:,:,randsubs(isb));
    start = tic;
    for j=1:length(randidxs) % loop on all voxels in the brain % XXX
        % for j=1:size(idx,1)
        databeam = dataonesub(:,idx(randidxs(j),:));
        x = databeam(labels==1,:);
        y = databeam(labels==2,:);
        delta = x-y;
        told(j,isb) = calcTstatMuniMeng([],delta);
        tnew(j,isb) = calcTstatMuniMengTwoGroup(x,y);
    end
    fprintf('finished sub %d in %f secs\n',isb,toc(start));
end
save('testToldTnew.mat','told','tnew');

figure;
for isb = 1:length(1);
    idxnanold = find(isnan(told(:,isb)));
    idxnannew = find(isnan(tnew(:,isb)));
    idxsout = unique([idxnanold,idxnannew]);
    idxskeep = setdiff(1:size(told,1),idxsout);
    r = corr([told(idxskeep,isb),tnew(idxskeep,isb)]);
    r = r(1,2);
    subplot(1,2,isb)
    scatter(told(:,isb),tnew(:,isb));
    xlabel('told');
    ylabel('tnew');    
    ttlstr = sprintf('pearson corr = %f',r);
    title(ttlstr)
end

end