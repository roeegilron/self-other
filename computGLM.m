function computGLM()
dirWithMdms = 'H:\1_AnalysisFiles\MRI_Data\MNI_analysis\multi_sub_analysis';
mdmFiles = findfiles(dirWithMdms,'*.mdm','depth=1');
for i = 2:length(mdmFiles)
    motionFilesOutput = [];
    mdm = BVQXfile(mdmFiles{i});
    motionFilesOutput = getMotionParamsFromMDM(mdm);
    % ComputeGLM options
    opts = struct( ...
        'motpars',   {motionFilesOutput(:)});
    glm = mdm.ComputeGLM(opts);
    glm.SaveAs([mdmFiles{i}(1:end-3) 'glm']);
    glm.ClearObject
end
end