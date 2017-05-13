function codeToFlattenVocalDataSet()
dirStatsReasults = 'F:\vocalDataSet\processedData\processedData';
statsResultsFodlers = ...
    {'stats','stats_normalized_only','stats_normalized_sep_beta','stats_smoothed_sep_beta'};
outputDir = 'F:\vocalDataSet\processedData\matFilesProcessedData';
matFilesDir = 'F:\vocalDataSet\processedData\matFilesProcessedData';
skipInitial = 0;
%% do initial file movement
if skipInitial
    %% make dirs to store data:
    for i = 1:length(statsResultsFodlers)
        mkdir(fullfile(outputDir,statsResultsFodlers{i}));
        mkdir(fullfile(outputDir,statsResultsFodlers{i},'maskFiles'));
    end
    
    %% loop on subjects and get mask file, copy them to output dir folders.
    subFolders = findFilesBVQX(dirStatsReasults,'sub*',struct('dirs',1,'depth',1));
    for i = 1:length(subFolders)
        for j = 1:length(statsResultsFodlers)
            % find mask files:
            maskFile = findFilesBVQX(fullfile(subFolders{i},statsResultsFodlers{j},'mask.nii'));
            subStr= regexp(subFolders{i},'[0-9]+','match');
            %         copyfile(maskFile{1},...
            %             fullfile(outputDir,statsResultsFodlers{j},'maskFiles',...
            %                 ['mask_' subStr{1} '_.nii']));
        end
    end
    %% copy motion figure
    motionFiles = findFilesBVQX(dirStatsReasults,'motion*.fig');
    for i = 1:length(motionFiles)
        subStr= regexp(motionFiles{i},'[0-9]+','match');
        copyfile(motionFiles{i},...
            fullfile(outputDir,'motionFiles',['motFig_' subStr{1} '.fig']))
    end
end
%% loop on subjects
n =  neuroelf;
subFolders = findFilesBVQX(dirStatsReasults,'sub*',struct('dirs',1,'depth',1));
for i = 1:length(subFolders)
    for j = 1:length(statsResultsFodlers)
        % find mask files:
        load(fullfile(...
            matFilesDir,statsResultsFodlers{j},'maskFiles','groupMaskFromRFXvocalDataSet.mat'))
        % find beta files
        betaFiles  = findFilesBVQX(...
            fullfile(subFolders{i},statsResultsFodlers{j},'beta*.nii'));
        subStr= regexp(subFolders{i},'[0-9]+','match');
        % loop on betas from the different conditions
        locations = getLocations(mask);
        if j < 3
            for k = 1:2
                [pn,betafn] = fileparts(betaFiles{k});
                vmp = n.importvmpfromspms(betaFiles{k},'a',[],3); % import at resolution 3mm
                dataRaw = vmp.Map.VMPData;
                vmp.ClearObject;
                clear vmp
                data(k,:) = reverseScoringToMatrix1rowAnsMat(dataRaw,locations);
                if k ==1
                    labels(k) = 1;
                else
                    labels(k) = 2;
                end
            end
        else
            for k = 1:40
                [pn,betafn] = fileparts(betaFiles{k});
                vmp = n.importvmpfromspms(betaFiles{k},'a',[],3); % import at resolution 3mm
                dataRaw = vmp.Map.VMPData;
                vmp.ClearObject;
                clear vmp
                data(k,:) = reverseScoringToMatrix1rowAnsMat(dataRaw,locations);
                if k <= 20
                    labels(k) = 1;
                else
                    labels(k) = 2;
                end
            end
        end
        
        matFileToSave = fullfile(matFilesDir,statsResultsFodlers{j},...
            ['data_' subStr{1} '.mat']);
        save(matFileToSave,'data','locations','mask','labels');
        clear data locations mask labels
        %         copyfile(maskFile{1},...
        %             fullfile(outputDir,statsResultsFodlers{j},'maskFiles',...
        %                 ['mask_' subStr{1} '_.nii']));
    end
end

%% create mask from ground truth maps I downloaded from neurvolt
% grounTruthMapVMP = ...
%     'D:\Roee_Main_Folder\1_AnalysisFiles\Poldrack_RFX\vocalDataSet\grounTruthMaps\spmT_0001.nii\spmT_0001_RFX_FromPaper.vmp';
% vmp = BVQXfile(grounTruthMapVMP);
% dataFromRFXpaper = vmp.Map.VMPData;
% dataFromRFXpaper(dataFromRFXpaper~=0) = 1;
% mask = dataFromRFXpaper;
% save('groupMaskFromRFXvocalDataSet.mat','mask');
%% create RFX data set:
for i = 3:length(statsResultsFodlers); % loop on normal /not
    matFiles = findFilesBVQX(...
        fullfile(matFilesDir,statsResultsFodlers{i}),...
        'data*.mat',...
        struct('dirs',0,...
        'depth',1));
    cnt = 1;
    for k = 1:length(matFiles); % loop on sub
        load(matFiles{k})
        for z = 1:2 % loop on labels
            idxLabel = find(labels == z);
            %% zscore data here
            data = zscore(data);
            outData(cnt,:) = mean(data(idxLabel,:),1);
            outLabels(cnt,1) = z;
            cnt = cnt + 1;
        end
    end
    fileNameToSave = ...
        fullfile(matFilesDir,statsResultsFodlers{i},...
        sprintf('RFXdata%s_zscored.mat',statsResultsFodlers{i}));
    data = outData;
    labels = outLabels;
    save(fileNameToSave,'data','labels','mask','locations');
end
end