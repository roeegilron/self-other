function motionFilesOutput= getMotionParamsFromMDM(mdm)
rootDir = 'H:\1_AnalysisFiles\MRI_Data\MNI_analysis\';
for i = 1:size(mdm.XTC_RTC,1)
    subNum = mdm.XTC_RTC{i,1}(end-17:end-14);
    run = num2str(str2num(mdm.XTC_RTC{i,1}(end-8))-1); % to get correct run num since num is off bcs of loocalizer
    motionParamDir = ['\s_' subNum '\functional\run' run '_ObsRun' run '\'];
    motionFiles = dir(fullfile(rootDir,motionParamDir,'rp*.txt'));
    [dx,dx] = sort([motionFiles.datenum],'descend');
    newestRPfilee = motionFiles(dx(1)).name;
    motionFilesOutput{i} = fullfile(rootDir,motionParamDir,newestRPfilee);
%     H:\1_AnalysisFiles\MRI_Data\MNI_analysis\s_2000\functional\run1_ObsRun1\rp*
end
end