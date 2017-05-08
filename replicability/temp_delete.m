% this function plots multi-t variabily
% At subject and group level
% full trials were used and estimates were not used in this itiration.
% This also tried to estimate the mixture probabtilities checking if they
% are one / not one. 
close all;
load harvard_atlas_short.mat;
rois = 1:111;
filepat = 'roi_%0.3d_shuf_*_inf_prev_80trials.mat';
rootdir = fullfile('..','..','results','Replicability','ss_infinite_prevelance_v2');
figdir = fullfile('..','..','figures','replicability','infinte_variability_shufs_median_centered');

%% agregate data from group prev Ruti: 
rutidir = fullfile('..','..','results','Replicability','group_prevelance_ruti');
subs = 3000:3022;
rois = 1:111;
% % output matrix is subject x shuffels x roi 
% for s = 1:length(subs)
%     for r = 1:length(rois)
%         load(fullfile(rutidir,sprintf('sub_%d_roi_%0.3d',subs(s),rois(r))));
%         alldata(s,:,r) = ansMat; 
%         pvals(s,r) = pval; 
%         clear ansMat pval 
%     end
% end
% save('temp.mat','alldata','pvals');
load('temp.mat'); 

rois = 1:111;
for r = rois
    %% Plot centered median variance within subject 
    % plot box plot
    dataplot = squeeze(alldata(:,2:end,r)');
    mediandataplot = median(dataplot,1);
    dataplotcented = dataplot - mediandataplot;
    realdata = squeeze(alldata(:,1,r)) - mediandataplot'; 
    centeredPrevForEst(:,1) = realdata; 
    centeredPrevForEst(:,2) = repmat(80,length(realdata),1);
    [percest(r), sig1(r) sig4(r), mucent(r)] = estimate_Prevelane2(centeredPrevForEst);
end

x=2; 