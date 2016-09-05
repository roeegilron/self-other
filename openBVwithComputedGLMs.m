function openBVwithComputedGLMs()
rootDir = 'H:\1_AnalysisFiles\MRI_Data\MNI_analysis\multi_sub_analysis';
vmrFileToUse = 'H:\1_AnalysisFiles\MRI_Data\MNI_analysis\s_2000\anatomical\run1\s_2000.vmr';
glmFiles = findFilesBVQX(rootDir,'*.glm','depth=1');
bvqx = actxserver('BrainVoyagerQX.BrainVoyagerQXScriptAccess.1');

for i = 1:length(glmFiles)
    vmrproject = bvqx.OpenDocument(vmrFileToUse);
    [~, glmFileName]=fileparts(glmFiles{i});
    bvqx.PrintToLog(['displaying ' glmFileName 'multi study ffx glm']);
    vmrproject.LoadGLM(glmFiles{i})
    % in order to display contrast need to add a contrast name and set to
    % this contrast. 
    vmrproject.AddContrast('self + other');
    vmrproject.SetCurrentContrast('self + other')
    vmrproject.SetContrastString('  1  1  0  1  1  0  1  1  0  1  1  0  1  1  0  1  1  0');
    vmrproject.ShowGLM()
end

end