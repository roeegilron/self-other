function checkLabelsSelfOtherCorrect()
correctlabeldir = 'D:\Roee_Main_Folder\1_AnalysisFiles\MRI_Data_self_otherv3\MRI_data\SubjectsData\subjects_3000_study\dataForServer_SepBeta\self_other';
dtafiles = findFilesBVQX(correctlabeldir,'*.mat');
for i = 1:length(dtafiles)
    [pn,fn] = fileparts(dtafiles{i});
    load(fullfile(pn,fn),'labels');
    labelscorrect.(['s' fn(end-3:end)]) = labels;
end

% results files: 
rsltdir = 'D:\Roee_Main_Folder\1_AnalysisFiles\Poldrack_RFX\matlabCode\results_self_other_FFX_ND_norm_100shuf_SL125';
rsltsfiles = findFilesBVQX(rsltdir,'*.mat');
for j = 1:length(rsltsfiles)
    [pn,fn] = fileparts(rsltsfiles{j});
    load(rsltsfiles{j},'labels');
    correctlabels = labelscorrect.(['s' fn(50:53)]);
    if length(labels) ~= length(correctlabels) % check size
        fprintf('sub %s no good\n',fn(50:53));
    else % they are equal but still more problems 
        if sum(labels~=correctlabels) > 0 
            fprintf('sub %s no good\n',fn(50:53)); % equal but some label mismatch 
        end
    end
end
end