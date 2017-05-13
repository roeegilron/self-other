function createAndSaveDataDirectioanlRFXvsFFX()
start = tic;
%% set params:
params = getParams();
numShuffels = 1e3;
slSize = 27;
runRFX = 1;
%%
%% load data
rootDirOriginalData = ...
    'F:\vocalDataSet\processedData\matFilesProcessedData\stats_normalized_sep_beta';
load(fullfile(rootDirOriginalData,'allSubsBetas.mat'),...
    'mask','locations','allSubsData','labels');

save(fullfile(rootDirOriginalData,'allSubsBetas-v7.mat'),...
    'mask','locations','allSubsData','labels','-v7');

%% look at raw data: 
subjectToCheck = [ 50 80 200 100];
subjectToCheck =  [   109   171    79   217   218     9    39   157   104    34   216   133    42   155    52   186    57   156    37  59];

voxTochk = 20;
figure;
for i = 1:length(subjectToCheck)
    subplot(4,5,i);
    hold on;
    rawDat = allSubsData(:,voxTochk,subjectToCheck(i));
    As = rawDat(labels==1); 
    Bs = rawDat(labels==2); 
    histogram(As,'BinWidth',0.5)
    histogram(Bs,'BinWidth',0.5)
    legend({'A','B'}); 
    xlabel('raw beta');
    ylabel('count');
    title(sprintf('sub %d vox %d',subjectToCheck(i),voxTochk));
    hold off;
end



%% loop on folds
folds = [20 21 ];%30 31];
folds = [30 31 ];%30 31];

for i = 1:length(folds)
    start = tic;
    cvfold = folds(i);
    %% select data
    [rawData,subsExtracted,numSubs] = extractSubjectsFromData(allSubsData,folds(i));
    %% create RFX data 
    [rfxData, shufMatrixRFX] = createRFXdata(rawData,numShuffels,labels);
    fnToSave = sprintf('precomputed_fixedshufflabels_Directional_RFX_Data_%d-subs_%d-shufs_cvFold%d.mat',...
                    numSubs,...
                    numShuffels,...
                    folds(i));
    %% save RFX data
    save(fnToSave,'rfxData','shufMatrixRFX','mask','locations','cvfold','subsExtracted','-v7.3');
    
    
    %% create FFX data 
    [ffxData, shufMatrixFFX] = createFFXdata(rawData,numShuffels,labels);
    fnToSave = sprintf('precomputed_Directional_FFX_Data_%d-subs_%d-shufs_cvFold%d.mat',...
                    numSubs,...
                    numShuffels,...
                    folds(i));
    %% save FFX data
    save(fnToSave,'ffxData','shufMatrixFFX','mask','locations','cvfold','subsExtracted','-v7.3');
    
    %% time report 
    fprintf('it took %f secs to do fold %d\n',toc(start),folds(i));
    clear rfxData ffxData shufMatrixFFX shufMatrixRFX
end

end