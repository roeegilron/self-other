function createPrtForAllSubjectsSelfOther()
subjects=2000:2006;
rootDir='C:\DATA\1_AnalysisFiles\MRI_Data\GLM_analysis';
rootDir2='C:\DATA\1_AnalysisFiles\FDR_searchLight_Analysis';
for i=1:length(subjects)
    for j=1:4
        seq=generateSequencesForGLM_PRT(subjects(i),j,0) ;%
        createPrt_self_other(subjects(i),j,seq)
        movefile(fullfile(rootDir2,[num2str(subjects(i)) '_prt_obs_Run_' num2str(j) '.prt']),...
            fullfile(rootDir,num2str(subjects(i)),[num2str(subjects(i)) '_prt_obs_Run_' num2str(j) '.prt']))
    end
end

% move prt into correct folders

end