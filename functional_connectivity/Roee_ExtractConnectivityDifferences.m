clear;clc;
dirs = {'self';'other'}; % the order here is important - 1 = self in output R_FC_d 
load('harvard_atlas_short');
frontal = 24;
temporal = 38;
parietal = 14;
occipital = 20;
subcortical=15;
p_thresh = 0.05;
num_of_shuffles = 1e3;

%pool = parpool('local');

%% load data 
%save('Real_R_FC.mat','R_FC_d');
firstidx = 1; secidx = 2;  % subtract what from what - firstidx = 1 is self 
datadir = fullfile('..','..','results','Functional_Connectivity');
fnuse = 'FC_self_vs_other_runs1-4_not-smoothed.mat'; %'Real_R_FC.mat';
load(fullfile(datadir,fnuse)); % 1 is self  2 is other  

%% exclude subjects 
 %pool = parpool('local');
sublist = [3000:3022]; 
% 3002 - larger number of slcies 
% 3015 - retarted 
% 3005 - didn't pay attention to task 
% 3012 - big right ventricle 

subexclude = [3015 3005 3012 ]; % exclude subjects with only 3 runs... 
subexclude = []; % exclude subjects with only 3 runs... 
[subsuse ia] = setdiff(sublist,subexclude);
R_FC_d = R_FC_d(:,ia,:); % if you want to exclude some subjects 
%% 


real_R_FC = (R_FC_d(firstidx,:,:) - R_FC_d(secidx,:,:)); % this is the subtrraction. 
real_R_FC = reshape(real_R_FC,size(real_R_FC,2),size(real_R_FC,3));

% keep in mind that it uses the same shuffle for all subjects in each
% shuffle 
parfor shuf=1:num_of_shuffles % shuffle paires of regions and subtract 
    perm = randperm(size(R_FC_d,3));
    shuffle_R_FC(shuf,:,:) = (R_FC_d(firstidx,:,perm) - R_FC_d(secidx,:,perm));
end

real_R_FC = mean(real_R_FC ,1); % average differences real vector of real 
shuffle_R_FC= mean(shuffle_R_FC,2); % average differnces shuffle 
shuffle_R_FC = reshape(shuffle_R_FC,size(shuffle_R_FC,1),size(shuffle_R_FC,3)); % shuf x regions 

for ix=1:size(shuffle_R_FC,2) % calcaulte signifiace for eahc pair 
    shuffle_R_FC_pair = sort(shuffle_R_FC(:,ix));
    real_R_FC_pair = real_R_FC(ix);
    x1 = find(real_R_FC_pair >=shuffle_R_FC_pair);
    
    if (~isempty(x1))
        pair_sig = 1-(x1(end)/(num_of_shuffles));
    else
        pair_sig = 1;
    end
    pair_sigs(ix) = pair_sig; % vector in lenght of reiongs that is the paairs. P of each pair
end



%h = zeros(length(pair_sigs),1);
%h((pair_sigs<p_thresh/length(pair_sigs)))=1;
[h, crit_p, adj_p]=fdr_bh(pair_sigs,p_thresh ,'pdep','no'); % do fdr 

%eval (['multi_subject_voxels_' num2str(count) ' = h;']);
%x_flat = R_FC;
x_flat  = h;
x_flat(h~=1) = 0;
x_flat(x_flat<=0) = 0;
if firstidx == 1 
    save('self_data.mat'); 
else
    save('other_data.mat'); 
end


hfig = figure;
if firstidx == 1 
    title('self'); 
else
    title('other'); 
end

incdudeThicknessofReal  = 1; 
x_flat = double(x_flat); 
if incdudeThicknessofReal 
    x_flat(h) = real_R_FC(h).*1e3;
end

x=double(squareform(x_flat));
myColorMap = [cool(frontal); autumn(temporal); summer(parietal); spring(occipital); copper(subcortical)];
circularGraph(x,'Colormap',myColorMap,'Label',ROI_BY_REGIONS);

if firstidx == 1 
    saveas(hfig,'self.fig');
else
    saveas(hfig,'other.fig');
end
%save('sig_connectivities.mat','multi_subject_voxels_1','multi_subject_voxels_2','multi_subject_voxels_3');