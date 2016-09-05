%% get data

%% from jochne 
% n = neuroelf;
% voivoxidx = n.bvcoordconv( voi.VOI(1).Voxels, 'bvi2bvx', glmseclev.BoundingBox) ;
% 
% voibetas = zeros(numel(voivoxidx), glm.NrOfPredictors) ;
% 
% for mc = 1:glm.NrOfPredictors
%    betamap = glm.GLMData.BetaMaps(:,:,:,mc) ;
%    voibetas(:,mc) = betamap(voivoxidx);
% end
% 
% end


close all; clear all; path(pathdef); clc;
skipthis = 0;
if skipthis
    addpath(genpath('H:\Poldrack_RFX_Project\toolboxes\neuroeflf\NeuroElf_v10_5153'));
    rootDir = 'H:\MRI_Data_self_other\subjects_3000_study\results_multi_smoothed';
    voifn = 'vois_all_self_other_vs_rest_multi_smoothed_defined_from_run1_OnlyPeakRegions.voi';
    glmfn = 'all_other_runs_ex_some_subs_VTC_N-53_RFX_ZT_AR-2_ITHR-100.glm';
    voi = BVQXfile(fullfile(rootDir,voifn));
    glmseclev = BVQXfile(fullfile(rootDir,glmfn));
    %% from jochen 
    
    % access to NeuroElf functions
    n = neuroelf;
    
    % copy VOI (from object in variable voi)
    voic = voi.CopyObject;
    
    % iterate over VOI indices
    for vc = 1:numel(voi.VOI)
        
        % assuming the GLM is in variable glm
        voi_indices = n.bvcoordconv(voi.VOI(vc).Voxels, 'tal2bvx', glmseclev.BoundingBox);
        
        % removing NaNs first (out-of-bounding-box voxels)
        voi_indices(isnan(voi_indices)) = [];
        
        % using unique, store into copy
        voi_indices = unique(voi_indices);
        voic.VOI(vc).Voxels = n.bvcoordconv(voi_indices, 'bvx2tal', glmseclev.BoundingBox);
        voic.VOI(vc).NrOfVoxels = numel(voi_indices);
    end
    %% 
    [vb, vbv, vbi] = glmseclev.VOIBetas(voic);
    subjects = glmseclev.Subjects;
    conditions = glmseclev.SubjectPredictors;
    conLabels = {'c','Ot','Oa','Or','St','Sa','Sr','Constant'};
    voinames = voi.VOINames;
    % vb is subjects x conditions x voi names
    for s = 1:size(vbv,1) % subjects
        for c = 2:7%1:size(vbv,2) % conditions
            for v = 1:size(vbv,3) % voinames (regions)
                outmat(v).forRDM(:,c-1,s) = vbv{s,c,v}(:);
            end
        end
    end
    save('ROIforMDS.mat','vbv','voinames','outmat','conditions','subjects','conLabels');
end
%%
load('ROIforMDS.mat','vbv','voinames','outmat','conditions','subjects','conLabels');
fold2save = fullfile('..','figures','simalarity');
savefigs = 1; 
% Ori's code - expects forRDM to be (voxels x conditions x subjects). 'One'
% forRAM matrix for each ROI. 

for voin = 1:length(voinames) % loop on voi name 
    
    forRDM = outmat(voin).forRDM;
    figtitle = sprintf('%s',voinames{voin});
    
    conditions = {'S1','S2','S3','O1','O2','O3'};
    conditions = conLabels(2:7);
    
    for s=1:size(forRDM,3)
        D_subjects(:,:,s) = pdist(forRDM(:,:,s)','euclidean');
    end
    D = mean(D_subjects,3);
    Y1=mdscale(D,2);
    
    % MDS
    fig_mds = figure();
    scatter(Y1(:,1),Y1(:,2),1e-2)
    text(Y1(:,1),Y1(:,2),conditions,'fontsize',8)
    set(fig_mds,'Color',[1 1 1])
    title(figtitle);
    axis off
    figname = sprintf('MDS_%s.jpeg',figtitle);
    if savefigs; saveas(fig_mds,fullfile(fold2save,figname)); end;
    
    % Similarity matrix
    distance_mat = squareform(D);
    similarity_mat = exp(-distance_mat)*100;
    fig_sim = figure();
    imagesc(similarity_mat);
    % caxis([16.39 22.57])
    colormap redbluecmap
    set(gca,'xtick',1:length(conditions),'xticklabels', conditions);
    set(gca,'ytick',1:length(conditions),'yticklabels', conditions);
    set(gcf,'Color',[1 1 1])
    title(figtitle);
    figname = sprintf('sim_matrix_%s.jpeg',figtitle);
    if savefigs; saveas(fig_sim,fullfile(fold2save,figname)); end;
    
    % % Dendograms
    fig_tree=figure();
    tree = linkage(D,'single');
    [H,T,outperm] = dendrogram(tree);
    set(gca,'xticklabel',conditions(outperm));
    set(gcf,'Color',[1 1 1]);
    title(figtitle);
    figname = sprintf('dendograms_%s.jpeg',figtitle);
    if savefigs; saveas(fig_tree,fullfile(fold2save,figname)); end;

end
