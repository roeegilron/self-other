clear;clc;
directory = 'self';
files = dir([directory '\*.mat']); % find subjects 
load('harvard_atlas_short');
frontal = 24; % for the colormaps for each lobe 
temporal = 38;
parietal = 14;
occipital = 20;
subcortical=15;
p_thresh = 0.05;% threhsold 

%% load data 
firstidx = 1; secidx = 2;  % subtract what from what - firstidx = 1 is self 
datadir = fullfile('..','..','results','Functional_Connectivity');
fnuse = 'FC_self_vs_other_runs1-4_not-smoothed.mat'; %'Real_R_FC.mat';
load(fullfile(datadir,fnuse)); % 1 is self  2 is other  
%% need to figure out how do compute significange... 
avgRs = mean(squeeze(R_FC_d(1,:,:)),1);
Rho = 0; % hypsothsized null correlation 
ts = avgRs-Rho ./ sqrt(1-avgRs.^2) ./ sqrt(size(R_FC_d,2)-1); % calculate T's from average r's 
ps = tcdf(ts,size(R_FC_d,2)-2,'upper'); % calculate ps.. .
[h, crit_p, adj_p]=fdr_bh(pair_sigs,p_thresh ,'pdep','no'); % do fdr 


h = zeros(length(FC),1); % this is boolean; 
h((FC<p_thresh/length(FC)))=1;
%eval (['multi_subject_voxels_' num2str(count) ' = h;']);
%x_flat = R_FC;
x_flat  = h; % this is what gets printed. R_FC is value of R so can print this to get lines by weight 
x_flat(h~=1) = 0; % what is not significant gets zero so its not printged. 
x_flat(x_flat<=0) = 0; % left over? sometimes R_FC is negative so this is for these cases 

figure;
x=double(squareform(x_flat));
myColorMap = [cool(frontal); autumn(temporal); summer(parietal); spring(occipital); copper(subcortical)];
circularGraph(x,'Colormap',myColorMap,'Label',ROI_BY_REGIONS);
title([directory]);

%save('sig_connectivities.mat','multi_subject_voxels_1','multi_subject_voxels_2','multi_subject_voxels_3');