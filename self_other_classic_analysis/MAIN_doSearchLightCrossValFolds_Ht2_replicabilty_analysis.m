function MAIN_doSearchLightCrossValFolds_Ht2_replicabilty_analysis()
start = tic;
params = getParams();
addPathsForServer();
subJs = input('how many subs? \n');
runRFX = input('run RFX?'); % 1 = run rfx, 0 = run FFX
numReps = input('how many reps? ');
for i = 1:numReps
    folds(i) = input(sprintf('fold for rep %d: ',i));
end
rootDir = 'F:\vocalDataSet\processedData\matFilesProcessedData\stats_normalized_sep_beta';
fn = 'RFXdatastats_normalized_sep_beta_.mat';
load(fullfile(rootDir,fn));
rawData = double(data);
rawLabels = labels;

for k = 1:numReps
    slSize = 27;
    params.regionSize = slSize;
    [data,labels,fnTosave,subsExtracted] = ...
        extractSubjectsFromDataRandmlyMODIFIED(rawData,rawLabels,subJs,slSize,folds(k));
    
    %% loop on all voxels in the brain to create T map
    idx = knnsearch(locations, locations, 'K', params.regionSize);
    % preallocate for memory
    ansMat = zeros(size(idx,1),1+params.numShuffels,7);
    % compute some intial values
    if runRFX
        [shufMatrix,shuffMatSVM] = createShuffIdxs(data,labels,params);
    else
        shufMatrix = createShuffMatrixFFX(data,params);
    end
    dataDelta = getDeltaOfData(data,labels,params);
    
    
%     try
        pool = startPool(params);
        fprintf('job took %f seconds to start parfor loop\n',toc(start));
        for i = 1:(params.numShuffels + 1)
            %don't shuffle first itiration
            if i ==1; params.shuffleData=0; else params.shuffleData=1 ;end;
            if ~runRFX && i~=1 % = if this is true run FFX
                dataDelta = getDeltaOfDataFFX(data,labels,shufMatrix(:,i-1));
            end
             %parfor (j=1:size(idx,1)) % loop on all voxels in the brain % XXX
                 for j=1:size(idx,1)
                delta = getDeltaFromBeam(dataDelta,labels,idx,j,i,params,shufMatrix,runRFX);
                [ansMatSVM(j,i)]  = calcSVM(data(:,idx(j,:)),labels,shuffMatSVM,i);
                [ansMat(j,i,:) ] = calcTstatAll(params,delta);
            end
            timeVec(i) = toc(start); reportProgress(fnTosave,i,params, slSize, timeVec)
        end
        sl = sprintf('SLsize%d_', params.regionSize);
        if runRFX
            fnTosave = [fnTosave '_RFX'];
        else
            fnTosave = [fnTosave '_FFX'];
        end
        save([fnTosave '_' datestr(clock,30) '.mat'],...
            'ansMat','ansMatSVM','mask','locations','params','subsExtracted','fnTosave','-v7.3');
        %     visualizeResults(ansMat,mask,locations,params);
        delete(pool);
        clear timeVec ansMat labels fnTosave
%     catch ME
        %save(['crashed_' datestr(clock,30) '.mat'],'-v7.3');
%         k = k-1;
%     end
end

end

