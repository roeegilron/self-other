function computeFFXresults_self_other_cross_validated_folds()
[ansMatOut,locations,map] = extractAndAverageData(); % average data across folds, get correcrt mask
[settings,params] = get_settings_params_self_other();

slsize = 50;
cntSubs = length(params.subuse);
ffxResFold = settings.resdir_ss_prev_cv;
outDir = settings.resdir_ss_prev_cv;
numMaps = 5e3;
fold = 4; % 4 runs


numshufs = size(ansMatOut,2)-1;
%% calc pvals for each subjects 
for s = 1:size(ansMatOut,3)
    pvalsOut(:,s) = calcPvalVoxelWise(squeeze(ansMatOut(:,:,s)));
end
logpvals = pvalsOut <= 0.05;
sigcount = sum(double(logpvals),2) / size(logpvals,2); 
%% compute the MSCM maps
for j = 1:numMaps+1
    if j == 1 % real map
        medianAnsMat(:,j) = nanmedian(ansMatOut(:,1,:),3);%% 
    else
        numSubs = size(ansMatOut,3);
        for k = 1:numSubs% extract rand map from each sub
            idxMap = randperm(numshufs,1) + 1; % first map is real
            tmp(:,k) = ansMatOut(:,idxMap,k);
        end
        medianAnsMat(:,j) = nanmedian(tmp,2);%% 
        clear tmp;
    end
    fprintf('finished comp map %d stlzr style\n',j);
end

clear ansMat;
% save different file based on dimension
ansMat = medianAnsMat;

[pn,fn]= fileparts(ffxResFold);
fnTosave = sprintf(...
    'Nondirection_FFX_median_self-other_%d-subs_%d-slsize_%d-cvFold_%d-shuf.mat',...
    numSubs,...
    slsize,...
    fold,...
    numshufs);
pval = calcPvalVoxelWise(ansMat);
ansMatReal = ansMat(:,1);
subsExtracted = params.subuse;
save(fullfile(outDir,fnTosave),...
    'pval','locations','map','fnTosave','ansMatReal','subsExtracted',...
    'pvalsOut');

end

function [ansMatOut,locations,map] = extractAndAverageData()
[settings,params] = get_settings_params_self_other();
slsize = 50;
cntSubs = length(params.subuse);
ffxResFold = settings.resdir_ss_prev_cv;
outDir = settings.resdir_ss_prev_cv;
numMaps = 20;
fold = 4; % 4 runs
srcpat = '1ND_FFX_s-%d_shufs-%d_cross_validate_newMultit*';
cnt = 1;
fnmsave = '2ndlevel_data.mat';
fullfnm = fullfile(outDir,fnmsave);
if exist(fullfnm,'file')
    load(fullfnm);
else
    %% get 3d mask from each subject
    cntsub = 1; 
    for i = params.subuse
        start = tic;
        subStrSrc = sprintf(srcpat,i,params.numshufs);
        ff = findFilesBVQX(ffxResFold,subStrSrc);
        if ~isempty(ff) % file doesn't exist
            load(ff{1},'mask','locations')
            if cntsub == 1
                mapout = logical(mask);
            else
                mapout = mapout & logical(mask);
            end
            fprintf('sub %s %d voxels extracted in %f\n',subStrSrc,...
                sum(mask(:)), toc(start));
            subsfound(cntsub) = i; 
            cntsub = cntsub + 1;
        end
    end
    locationsgood = getLocations(mapout);
    
    %% loop on subject, average data,
    % 1. average data per subject
    % 2. put averaged data in 3d structure
    % 3. mask with group map
    % 4. move back to 2d
    cnt = 1;
    for i = params.subuse
        start = tic;
        subStrSrc = sprintf(srcpat,i,params.numshufs);
        ff = findFilesBVQX(ffxResFold,subStrSrc);
        if ~isempty(ff) % if sub doesn't exist report that 
            load(ff{1},'ansMat','mask','locations')
            % average cross validation folds:
            ansMatAvg = mean(ansMat,3);
            % loop on shuffels, put each in 3D move back to 2D
            for s = 1:size(ansMatAvg,2)
                tempDat3D = scoringToMatrix(mask, ansMatAvg(:,s), locations);
                ansMatOut(:,s,cnt) = reverseScoringToMatrixForFlat(tempDat3D, locationsgood);
            end
            subsfound(cnt) = i; 
            cnt = cnt + 1;
            fprintf('sub %s averaged and extracted in %f\n',subStrSrc,toc(start));
        end
    end
    map = mapout; 
    locations = locationsgood; 
    save(fullfnm,'ansMatOut','map','locations','subsfound'); 
end
end