function MAIN_compute_correlations_to_behav_with_vois()
rootDir = 'D:\Roee_Main_Folder\1_AnalysisFiles\MRI_Data_self_otherv3\MRI_data\SubjectsData\subjects_3000_study';
secleveldir = 'results_multi_smoothed';
prefixvmps  = '*_multi_7_conds*.vmp';
prefixglms  = 'multi_7_conds_*.glm';
multiglmfn = 'ALL_SUBS_VTC_N-47_RFX_ZT_AR-2_ITHR-100.glm';
glmseclev = BVQXfile(fullfile(rootDir,secleveldir,multiglmfn));
vmpfiles = findFilesBVQX(rootDir,prefixvmps);
glmfiles = findFilesBVQX(rootDir,prefixglms);

close all; clear all; path(pathdef); clc;
addpath(genpath('H:\Poldrack_RFX_Project\toolboxes\neuroeflf\NeuroElf_v10_5153'));
rootDir = 'H:\MRI_Data_self_other\subjects_3000_study\results_multi_smoothed';
voifn = 'vois_all_self_other_vs_rest_multi_smoothed_defined_from_run1_FDR-0005.voi';
glmfn = 'all_other_runs_ex_some_subs_VTC_N-53_RFX_ZT_AR-2_ITHR-100.glm';
voi = BVQXfile(fullfile(rootDir,voifn));
glmseclev = BVQXfile(fullfile(rootDir,glmfn));
[vb, vbv, vbi] = glmseclev.VOIBetas(voi);
subjects = glmseclev.Subjects; 
conditions = glmseclev.SubjectPredictors; 
conLabels = {'c','Ot','Oa','Or','St','Sa','Sr','Constant'};
voinames = voi.VOINames;
contrastToCheck = [0 -1 -1 -1 1 1 1 0]; % self vs other 
% vb is subjects x conditions x voi names 

%% compute p value of differences 
for i = 1:size(vb,3) % loop on vois 
    idxsCon1 = contrastToCheck==1; % self 
    idxsCon2 = contrastToCheck==-1; % other 
    data1 = mean(vb(:,idxsCon1,i),2);
    data2 = mean(vb(:,idxsCon2,i),2);
    [h,p] = ttest(data1,data2);
    subplot(4,4,i); 
    boxplot([data1,data2]);
    
    fprintf('[%d] voi - %s \t [p] %.2f\n',i,voinames{i},p)
end

for i = 1:size(vbv,1)
    tmp(i,:) = vbv{i,1,1};
end
%% compute simalarity matrices across conditions 
% vb is subjects x conditions x voi names 

for s = 1:size(vbv,1)
    for i = 1:size(vb,3) % loop on voi
        for j = 2:7 % loop on conditions
            for k = 2:7  % loop on conditions
                %sim_mat(j-1,k-1,i) = corr(vb(:,j,i),vb(:,k,i));% summery stat
                tmp1 = vbv{s,j,i}; tmp2 = vbv{s,k,i}; % within each subject - correlations between conditions  
                %             fprintf('[%d] m = %.2f \t [%d], m = %.2f\n',j,mean(tmp1),k,mean(tmp2));
                sim_mat(j-1,k-1,i,s) = corr(tmp1,tmp2,'type','spearman'); % con x con x region x subject
            end
        end
    end
end
mean_across_subs = mean(sim_mat,4);
for i = 1:size(mean_across_subs,3);
    figure;imagesc(sim_mat(:,:,i))
    set(gca,'XTickLabel',conLabels(2:7));
    set(gca,'YTickLabel',conLabels(2:7));
    colorbar;
    title(voinames{i});
end

%% compute simlarity matrices across averaged conditions 
clear sim_mat;
consuse(:,1) = [0 0 0 0 1 1 1 0]; % self
consuse(:,2) = [0 1 1 1 0 0 0 0]; % other
consuse = consuse';
conLabels = {'S','O'};
for i = 1:size(vb,3) % loop on voi
    for j = 1:2 % loop on conditions
        for k = 1:2  % loop on condition
            idxj = find(consuse(j,:)==1);
            idxk = find(consuse(k,:)==1);
            data1 = mean(vb(:,idxj,i),2);
            data2 = mean(vb(:,idxk,i),2);
            sim_mat(j,k,i) = corr(data1,data2);
        end
    end
    figure;imagesc(sim_mat(:,:,i))
    set(gca,'XTickLabel',conLabels);
    set(gca,'YTickLabel',conLabels);
    colorbar;
    title(voinames{i});
end


% compute simlarity matrices across regions 


for j = 1:voi.NrOfVOIs
    for i = 1:length(vmpfiles) % loop on vmp and vois and extract values
        glm = BVQXfile(glmfiles{j}); 
        void = voi.Details(vmp,1);
    end
end