function computeFFXresults_self_other(subsToExtract,fold,computeStzler,ffxResFold,outDir,numMaps)
computeStzler ;  % - > compute FFX maps stezler way to get 1000 MSCMS from only 100 possible median maps.
% ansMat(voxles,shuffles,stats);
slsize = 27;
cntSubs = length(subsToExtract);
cnt = 1;
for i = subsToExtract
    start = tic;
    subStrSrc = sprintf('*%3.3d*.mat',i);
    ff = findFilesBVQX(ffxResFold,subStrSrc);
    load(ff{1},'ansMat','locations','mask')
%     ansMat = squeeze(ansMat);
    % zero all nana idxs
    %     idxNans = find(isnan(median(ansMat,2))==1);% median on nan gives NaN...
    %     ansMat(idxNans,:) = 0;
    %     fprintf('sub %d has %d nans\n',i,sum(isnan(median(ansMat,2))))
    fprintf('sub %s extracted in %f\n',subStrSrc,toc(start));
    ansMatOut(:,:,cnt) = ansMat;
    cnt = cnt + 1;
end
% find out how many hsufs you have

if ndims(ansMatOut) == 3
    numshufs = size(ansMatOut,3)-1;
elseif ndims(ansMatOut) == 4
    numshufs = size(ansMatOut,2)-1;
end
%% compute the MSCM maps
if computeStzler
    for j = 1:numMaps+1
        if j == 1 % real map
            if ndims(ansMatOut) == 3
                medianAnsMat(:,j) = nanmean(ansMatOut(:,1,:),3);%% XXX  use mean
            elseif ndims(ansMatOut) == 4
                % ansMat(voxles,shuffles,stats);
                % ansMatOut(voxels,shuffels,stats,subjects);
                ansMatLarge(:,j,:) = nanmean(ansMatOut(:,1,:,:),4);
            end
        else
            if ndims(ansMatOut) == 3
                numSubs = size(ansMatOut,3);
            elseif ndims(ansMatOut) == 4
                numSubs = size(ansMatOut,4);
            end
            for k = 1:numSubs% extract rand map from each sub
                idxMap = randperm(numshufs,1) + 1; % first map is real
                if ndims(ansMatOut) == 3
                    tmp(:,k) = ansMatOut(:,idxMap,k);
                elseif ndims(ansMatOut) == 4
                    tmp(:,k,:) = ansMatOut(:,idxMap,:,k);
                end
            end
            % ansMat(voxles,shuffles,stats);
            % ansMatOut(voxels,shuffels,stats,subjects);
            if ndims(ansMatOut) == 3
                medianAnsMat(:,j) = nanmean(tmp,2);%% use MEAN was median
            elseif ndims(ansMatOut) == 4
                ansMatLarge(:,j,:) = nanmean(tmp,2);
            end
        end
        clear tmp;
        fprintf('finished comp map %d stlzr style\n',j);
    end
else
    medianAnsMat = mean(ansMatOut,3);% XXX use mean was median
end
clear ansMat;
% save different file based on dimension
if ndims(ansMatOut) == 3
    ansMat = medianAnsMat;
elseif ndims(ansMatOut) == 4
    ansMat = ansMatLarge;
end

[pn,fn]= fileparts(ffxResFold);
if computeStzler
    fnTosave = sprintf(...
        'Nondirection_FFX_words_%d-subs_%d-slsize_%d-cvFold_%d-shuf.mat',...
        numSubs,...
        slsize,...
        fold,...
        numshufs);
else
    fnTosave = sprintf('Self-other_results_%d-subs_27-slSize_cvFold%d_FFX.mat',cntSubs,fold);
end
pval = calcPvalVoxelWise(ansMat);
ansMatReal = ansMat(:,1); 
subsExtracted = subsToExtract;
save(fullfile(outDir,fnTosave),...
    'pval','locations','mask','fnTosave','ansMatReal','subsExtracted');
end