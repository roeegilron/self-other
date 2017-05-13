function computeFFXresultsOld2008T(subsToExtract,fold,computeStzler,ffxResFold,outDir,numMaps)
computeStzler =1;  % - > compute FFX maps stezler way to get 1000 MSCMS from only 100 possible median maps.
% ansMat(voxles,shuffles,stats);
slsize = 27;
cntSubs = length(subsToExtract);
cnt = 1;
for i = subsToExtract
    start = tic;
    subStrSrc = sprintf('*s%.3d*.mat',i);
    ff = findFilesBVQX(ffxResFold,subStrSrc);
    load(ff{1},'ansMat','locations','mask')
%     ansMat = ansMatOld(:,:,1); % first val is multi t 2008
%     ansMat = squeeze(ansMat);
    % zero all nana idxs
    %     idxNans = find(isnan(median(ansMat,2))==1);% median on nan gives NaN...
    %     ansMat(idxNans,:) = 0;
    %     fprintf('sub %d has %d nans\n',i,sum(isnan(median(ansMat,2))))
    fprintf('sub %s extracted in %f\n',subStrSrc,toc(start));
    ansMatOut(:,:,cnt) = squeeze(ansMat(:,:,1));
    cnt = cnt + 1;
end
% find out how many hsufs you have
numshufs = size(ansMatOut,2)-1;

%% compute the MSCM maps
if computeStzler
    for j = 1:numMaps+1
        if j == 1 % real map
            tmp = squeeze(ansMatOut(:,1,:));
            medianAnsMat(:,j) = nanmean(tmp,2);
        else
            numSubs = size(ansMatOut,3);
            for k = 1:numSubs% extract rand map from each sub
                idxMap = randperm(numshufs,1) + 1; % first map is real
                tmp(:,k) = ansMatOut(:,idxMap,k);
            end
            medianAnsMat(:,j) = nanmean(tmp,2);%% use MEAN was median
        end
        clear tmp;
        fprintf('finished comp map %d stlzr style\n',j);
    end
else
    medianAnsMat = nanmean(ansMatOut,3);% XXX use mean was median
end
clear ansMat;
ansMat = medianAnsMat;

[pn,fn]= fileparts(ffxResFold);
if computeStzler
    fnTosave = sprintf(...
        'Nondirection_FFX_vocalDataset_%d-subs_%d-slsize_%d-cvFold_%d_sufs_%d_shuf-stlzer_oldT2008.mat',...
        numSubs,...
        slsize,...
        fold,...
        numshufs,...
        numMaps);
else
    fnTosave = sprintf('VocalDataSet_results_%d-subs_27-slSize_cvFold%d_FFX_oldT2008_notstelzer.mat',cntSubs,fold);
end
pval = calcPvalVoxelWise(ansMat);
subsExtracted = subsToExtract;
save(fullfile(outDir,fnTosave),...
    'ansMat','locations',...
    'mask','fnTosave','subsExtracted');
end