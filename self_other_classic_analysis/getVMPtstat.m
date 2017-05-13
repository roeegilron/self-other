function vmp = getVMPtstat(ansMat,pn,fn,locations,mask,vmp)
% create vmp with t stat data  
ansMatAverage(:,2) = ansMat(:,1); % first column is real data 
ansMatAverage(:,1) = 1:size(ansMat,1);


% This is the original data 
% just load this temp 
if sum(size(mask)) > 250 % russ's mask is 91x109x91
    dataFromAnsMatBackIn3d = scoringToMatrix(mask,ansMatAverage,locations);
    %% add this map to the vmp
    curMapNum = vmp.NrOfMaps + 1;
    vmp.NrOfMaps = curMapNum;

    niftiData = load_nii(fullfile(pwd,...
        'thresholded_searchlight_results_0.6_2mm_pumpVcashout.nii.gz')); % this is dummy nifty data
    niftiData.img = dataFromAnsMatBackIn3d;
    save_nii(niftiData,fullfile(pn,[fn '.nii']));
    n = neuroelf;
    vmpTstat = n.importvmpfromspms(fullfile(pn,[fn '.nii']),'a',[],2);
    vmp.Map(curMapNum) = vmpTstat.Map;
else
    % you have to use the old version 
    % in which instead of mask you give number 
    dataFromAnsMatBackIn3d = scoringToMatrix(128,ansMatAverage,locations);
%     fmrData = scoringToMatrix(128, ansMat, locations);
    outputData(1).data = strechMatrix(locations, locations, dataFromAnsMatBackIn3d);
    outputData(1).mapName = fn(1:end-4) ;
    outputData(1).lowerThresh = 0;
    outputData(1).upperThresh = 2;
%     writeToVmpTAL_multipleMaps([fn(1:end-3) 'vmp'], outputData, mask,3)

    %% add this map to the vmp
    curMapNum = 1; % the raw t map is always the first map 
    vmp.NrOfMaps = curMapNum;
    vmp.Map(curMapNum).VMPData = dataFromAnsMatBackIn3d;
end
% set some map properties 
vmp.Map(curMapNum).LowerThreshold = 0.3;
vmp.Map(curMapNum).UpperThreshold = 5;
vmp.Map(curMapNum).Name = fn;
% vmp.Map.RGBLowerThreshPos = [ 0 0 255];
% vmp.Map.RGBUpperThreshPos = [ 0 0 255];
% vmp.Map.RGBLowerThreshNeg = [ 0 0 255];
% vmp.Map.RGBUpperThreshNeg = [ 0 0 255];
% vmp.Map.UseRGBColor = 1; 
end