function MAIN_doSearchLight_Directional_basedOnFFX_ND()
% This function uses previously run ND-FFX shuf matrices
% And runs a Directional FFX searchlight
subsToExtract = [20,150];
slsize = 27;
numshufs = 50;
ffxResFold = 'D:\Roee_Main_Folder\1_AnalysisFiles\Poldrack_RFX\matlabCode\results_vocal_dataset_FFX_ND_norm_100shuf_SL27_compre_old_new_t';
resultsDir = 'F:\vocalDataSet\processedData\matFilesProcessedData\vocalDataSetResults\DirectionalVsNondirectionalFFX';
params = getParams;
params.numShuffels = numshufs;
params.regionSize = slsize;
params.numShuffels = numshufs;



for i = 2:length(subsToExtract) % loop on fold 20 / 150 subjects
    substorun = subsUsedGet(subsToExtract(i)); % 150 / 20 for vocal data set
    fnTosave = sprintf('Directional_FFX_vocalDataset_%d-subs_%d-slsize_1-cvFold_50-shuf-stlzer_newT2013.mat',...
        slsize,subsToExtract(i));
    timeVec = [];
    for k = 1:numshufs + 1 % loop on shuffels
        for s = 1:length(substorun) % get data from each subject
            % find the data for this subject:
            ff = findFilesBVQX(ffxResFold,sprintf('*sub_%.3d*.mat',substorun(s)));
            load(ff{1},'data','mask','labels','shufMatrix','locations');
            %don't shuffle first itiration
            if k ==1 % don't shuffle data
                labelsuse = labels;
            else % shuffle data
                labelsuse = labels(shufMatrix(:,k-1));
            end
            dataX = mean(data(labelsuse==1,:),1); % mean delta x
            dataY = mean(data(labelsuse==2,:),1); % mean delta y
            delta(s,:) = dataX-dataY;
            % get delta data from each subject according to the shuff matrix
        end
        start = tic;
        idx = knnsearch(locations, locations, 'K', slsize);
        for j=1:size(idx,1) % loop onvoxels
            deltabeam = delta(:,idx(j,:));
            [ansMat(j,k,:) ] = calcTstatAll([],deltabeam);
        end
        clc
        timeVec(k) = toc(start); reportProgress(fnTosave,k,params, slsize, timeVec);
    end
    
    pval = calcPvalVoxelWise(squeeze(ansMat(:,:,1)));
    SigFDR = fdr_bh(pval,0.05,'pdep','no');
    ansMatReal = squeeze(ansMat(:,1,1));
    subsExtracted = substorun;
    save(fullfile(resultsDir,fnTosave),...
        'ansMat','ansMatReal','pval',...
        'locations','mask','fnTosave','subsExtracted','SigFDR');
end
    
end
