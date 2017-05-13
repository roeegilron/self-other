function createInclusiveMask()
dirStatsReasults = 'F:\vocalDataSet\processedData\matFilesProcessedData';
statsResultsFodlers = ...
    {'stats','stats_normalized_only','stats_normalized_sep_beta','stats_smoothed_sep_beta'};
n = neuroelf; 
for i = 1:length(statsResultsFodlers)
    % get mask files 
    maskFiles = findFilesBVQX(fullfile(dirStatsReasults,statsResultsFodlers{i},'maskFiles'),...
        'mask*.nii');
    for j = 1:length(maskFiles)
        vmp = n.importvmpfromspms(maskFiles{j},'a',[],3); % import at resolution 3mm
        maskData = vmp.Map.VMPData;
        if j ~= length(maskFiles) % want to to save the last vmp. 
        [~] = evalc('vmp.ClearObject');
        clear vmp
        end
        % since its imported at res [3] --> get ride of interpoldated 0.5
        % value; 
        maskData(maskData<1) = 0;
        if j == 1; 
            outMask = single(zeros(size(maskData)));
            outMask = maskData;
        else 
            outMask = outMask & maskData;
            outMaskAllMaps(:,:,:,j) = maskData;
        end
        [fn,pn] = fileparts(maskFiles{j});
        fprintf('finished masking file %s num voexl %d\n '...
            ,pn,sum(sum(sum(outMask))));
    end 
    vmpfileNameToSave = fullfile(fn,'groupMask.vmp');
    matfilenameTosave = fullfile(fn,'outMask.mat');
    matfilenameTosave2 = fullfile(fn,'outMask_allMaskFiles.mat');
    vmp.Map.VMPData = outMask;
    vmp.Map(1).Name = sprintf('all subs %d voxels',sum(sum(sum(outMask))));
    vmp.Map(1).LowerThreshold = 0;

    %% add a few alternative masks: 
    numSubsOver = [200,180,150]; 
    for z = 1:length(numSubsOver)
        curMap  = vmp.NrOfMaps + 1;
        vmp.NrOfMaps = curMap;
        maskOver = sum(outMaskAllMaps,4) > numSubsOver(z);
        vmp.Map(curMap) = vmp.Map(curMap-1); 
        vmp.Map(curMap).VMPData = maskOver;
        vmp.Map(curMap).Name = sprintf('mask with over %d subs %d voxels',numSubsOver(z),sum(sum(sum(maskOver))));
        vmp.Map(curMap).LowerThreshold = 0;
    end
    vmp.SaveAs(vmpfileNameToSave)
    vmp.ClearObject; 
    clear vmp 
    save(matfilenameTosave,'outMask');
    save(matfilenameTosave2,'outMaskAllMaps');
end
end