function visualizeResultsSelfOther()
resltsdir = 'D:\Roee_Main_Folder\1_AnalysisFiles\MRI_Data_self_otherv3\MRI_data\SubjectsData\subjects_3000_study\results_self_other_sub_beta\';
subdir = 'self-other';
resltsdir = fullfile(resltsdir,subdir);
fn = 'Nondirection_FFX_self-other_12-subs_125-slsize_1-cvFold_11-shuf.mat';
load(fullfile(resltsdir,fn));
% pval = calcPvalVoxelWise(ansMat);
%% fdr control
cutOff = 0.05;
SigFDR = fdr_bh(pval,cutOff,'pdep','no');
% Pval(Pval>cutOff) = 0;
SigFDR = double(SigFDR);
% save vmp: 
vmp = BVQXfile('vmp');
mapstruc = vmp.Map;
for i = 1:2
    if i ==1
        vmpdat = scoringToMatrix(mask,SigFDR',locations); % note that SigFDR must be row vector 
        mapname = fn(1:end-4);
        lowthres = 0; upperthresh = 2;
    else
        vmpdat = scoringToMatrix(mask,ansMatReal,locations); % note that SigFDR must be row vector 
        mapname = 'ansmatreal';
        lowthres = 0; upperthresh = max(ansMatReal);
    end
    vmpdat = single(vmpdat);
    vmp.Map(i) = mapstruc;
    vmp.Map(i).Name = mapname;
    vmp.Map(i).VMPData = vmpdat;
    vmp.Map(i).LowerThreshold = 0;
end
vmp.NrOfMaps = 2;
vmp.SaveAs(fullfile(resltsdir,[fn(1:end-4) '.vmp']))
end