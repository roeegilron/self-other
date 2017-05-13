function createSomeVMPmapsVocalDataSet()
vmpGrunTruth = fullfile(...
    'D:\Roee_Main_Folder\1_AnalysisFiles\Poldrack_RFX\vocalDataSet\grounTruthMaps\spmT_0001',...
    'spmT_0001_RFX_FromPaper.vmp');
vmp = BVQXfile(vmpGrunTruth);
voxelPasing = sum(sum(sum(vmp.Map.VMPData>4.79)));
addstr= sprintf(' voxl passing %d',voxelPasing);
vmp.Map.Name = [vmp.Map.Name addstr];
vmp.Map(1).LowerThreshold = 4.79;
vmp.Map(1).RGBLowerThreshPos = [ 0 0 255];
vmp.Map(1).RGBUpperThreshPos = [ 0 0 255];
vmp.Map(1).RGBLowerThreshNeg = [ 0 0 255];
vmp.Map(1).RGBUpperThreshNeg = [ 0 0 255];
vmp.Map(1).UseRGBColor = 1; 


%% load map
dirRes = 'F:\vocalDataSet\processedData\matFilesProcessedData\vocalDataSetResults\RFX_results';
fnResF= 'VocalDataSet_results_218-subs_27-slSize_cvFold50_RFX_zscored_20150821T102606.mat';

load(fullfile(dirRes,fnResF));

Pval = calcPvalVoxelWise(ansMat);
% bcs of BV display issues, set Pval over cut off val to zero
%% fdr control
cutOffs = [0.05, 0.01];
for i = 1:length(cutOffs)

    SigFDR = fdr_bh(Pval,cutOffs(i),'pdep','no');
    % Pval(Pval>cutOff) = 0;
    SigFDR = double(SigFDR);
    if sum(SigFDR) ==0 % no maps passed thresh
        fprintf('no voxels passed thresh at p %f \n',cutOffs(i));
%         return
    end
    SigFDR(SigFDR ==1) = 10; % make the value bigger artificially so it displays on VMP
    dataFromAnsMatBackIn3d = scoringToMatrix(mask,SigFDR,locations);
    voxelPasing = sum(sum(sum(dataFromAnsMatBackIn3d>1)));
    
    curMapNum = vmp.NrOfMaps + 1;
    vmp.NrOfMaps = curMapNum;
    % set some map properties
    vmp.Map(curMapNum) = vmp.Map(1);
    vmp.Map(curMapNum).VMPData = dataFromAnsMatBackIn3d;
    vmp.Map(curMapNum).LowerThreshold = 0;
    vmp.Map(curMapNum).UpperThreshold = 10;%XXX cutOff;
    vmp.Map(curMapNum).RGBLowerThreshPos = [ 255 255 0];
    vmp.Map(curMapNum).RGBUpperThreshPos = [ 255 255 0];
    vmp.Map(curMapNum).RGBLowerThreshNeg = [ 255 255 0];
    vmp.Map(curMapNum).RGBUpperThreshNeg = [ 255 255 0];
    vmp.Map(curMapNum).UseRGBColor = 1;
    addstr= sprintf(' voxl passing %d',voxelPasing);
    vmp.Map(curMapNum).Name = ['P_FDR_corrected_' num2str(cutOffs(i))  '-' fnResF(1:50) addstr];
end
%% FWE control
cutOffs = [0.05, 0.01];
for i = 1:length(cutOffs)
    maxVals = sort( max(ansMat(:,2:end),[],1));
    idxUseCutOff = (size(ansMat,2)-1)*(1-cutOffs(i));
    cutOff = maxVals(idxUseCutOff);
    voxelPasing = sum(ansMat(:,1)>cutOff);
    idx2Pass = find(ansMat(:,1)>cutOff);
    fweMap = zeros(size(Pval));
    fweMap(idx2Pass) = 10;
    dataFromAnsMatBackIn3d = scoringToMatrix(mask,fweMap,locations);
    curMapNum = vmp.NrOfMaps + 1;
    vmp.NrOfMaps = curMapNum;
    % set some map properties
    vmp.Map(curMapNum) = vmp.Map(1);
    vmp.Map(curMapNum).VMPData = dataFromAnsMatBackIn3d;
    vmp.Map(curMapNum).LowerThreshold = 0;
    vmp.Map(curMapNum).UpperThreshold = 10;%XXX cutOff;
    vmp.Map(curMapNum).RGBLowerThreshPos = [ 255 255 0];
    vmp.Map(curMapNum).RGBUpperThreshPos = [ 255 255 0];
    vmp.Map(curMapNum).RGBLowerThreshNeg = [ 255 255 0];
    vmp.Map(curMapNum).RGBUpperThreshNeg = [ 255 255 0];
    vmp.Map(curMapNum).UseRGBColor = 1; 

    addstr= sprintf(' voxl passing %d',voxelPasing);
    vmp.Map(curMapNum).Name = ['P_FWE_corrected_' num2str(cutOffs(i))  '-' fnResF(1:50) addstr];
end

vmpSaveName = fullfile(dirRes,[fnResF(1:65) '.vmp'] );
vmp.SaveAs(vmpSaveName);
