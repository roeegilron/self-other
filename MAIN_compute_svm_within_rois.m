function MAIN_compute_svm_within_rois()
% load voi
p = genpath('D:\Roee_Main_Folder\1_AnalysisFiles\Poldrack_RFX\');
addpath(p);

voidir = 'D:\Roee_Main_Folder\1_AnalysisFiles\MRI_Data_self_otherv3\MRI_data\SubjectsData\subjects_3000_study\results_multi_smoothed';
voifn  = 'test_voi_spl_r.voi';
vtc = BVQXfile('D:\Roee_Main_Folder\1_AnalysisFiles\MRI_Data_self_otherv3\MRI_data\SubjectsData\subjects_3000_study\3001\functional\run1\3001_run1_SCCTBL_3DMCTS_THPGLMF2c_TAL.vtc');
voi = BVQXfile(fullfile(voidir,voifn));
msk = voi.CreateMSK(vtc.BoundingBox);
dirwithbeta = 'D:\Roee_Main_Folder\1_AnalysisFiles\MRI_Data_self_otherv3\MRI_data\SubjectsData\subjects_3000_study\dataForServer_SepBeta\self_other';
matfnms = findFilesBVQX(dirwithbeta,'data*.mat');
runfolds = [ones(42,1) ; ones(42,1)*2 ; ones(42,1)*3 ; ones(42,1)*4];
for i = 1:length(matfnms)
    load(matfnms{i});
    if length(labels)<160
        continue
    else
        maskidxs = reverseScoringToMatrix1rowAnsMat(double(msk.Mask),locations);
        idxsuse = find(maskidxs==1);
        % train set run 2
        idxtrain = [find(runfolds==2); find(runfolds==3)  ] ;
        idxtest = find(runfolds==1);
        % test set run 3
%         labelsuse = labels(randperm(length(labels)));
        labelsuse = labels;
        % reduce data suing SNR 
        idxa = find(labelsuse==1); idxb = find(labelsuse==2); 
        model = svmtrainwrapper(labelsuse(idxtrain),data(idxtrain,idxsuse));
        b = calcTstatMuniMengTwoGroup(data(labelsuse==1,idxsuse),data(labelsuse==2,idxsuse));
        [a, b , c] = svmpredictwrapper(labels(idxtest),data(idxtest,idxsuse),model);
%         acc(i) = b(1);
        fprintf('%f\n',b(1));
    end
end
vmp = BVQXfile('*.vmp');
vmp.Map.VMPData = double(msk.Mask);
vmp.SaveAs()
% to do - correlation between this measure and acc 
% go over different rois systematically 
% create personlized roi's 
% investigate this in the smoothed data 
end