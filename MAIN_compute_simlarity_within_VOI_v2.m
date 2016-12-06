function MAIN_compute_simlarity_within_VOI_v2()
%% This function runs simalarity analysis within ROI's
%% Finally it produces figures with simalrity measures
clc; clear all; close all;
[settings, params ] = get_settings_and_parms();
extractAndSaveDataFromVOI(settings,params);
voisff = findFilesBVQX(settings.resdir,'*.mat');
for i = 1:length(voisff)
    start = tic;
    load(voisff{i},'settings','data');
    if params.avgDistnace
        D = averageDistance(data);
    else
        meanD = averageData(data);
        D = computeDistance(meanD);
    end 
    computeMDS(D,settings,params);
    computeSimlariry(D,settings,params);
    computeDendograms(D,settings,params);
    fprintf('voi %d done in %f\n',i,toc(start));
end


end

function extractAndSaveDataFromVOI(settings,params)
vmp = BVQXfile(fullfile(settings.vmpdir,settings.vmpfn)); % voi was converted to vmp
for v = 2:vmp.NrOfMaps % first map is
    map3d = vmp.Map(v).VMPData;
    start = tic;
    datasub = {};
    map3dAllSub = getCommonLocFlat(settings,params,map3d);
    for s = 1:length(settings.subuse)
        data = getDataFromVOI(settings,params,s,map3d,map3dAllSub);
        datasub{s} = data;
    end
    % get voi name
    voiname = genvarname(strrep(strrep(vmp.Map(v).Name,')','_'),'(','_'));
    settings.curvoiname = voiname;
    
    saveData(datasub,map3d,voiname,settings,params,v-1);
    fprintf('voi %d done in %f\n',v-1,toc(start));
end
end

function rawmap = getCommonLocFlat(settings,params,map3d)
for s = 1:length(settings.subuse)
    for r = 1% loop on runs
        for c = 1 % loops onconditions
            fnsrc = sprintf(params.filestr,...
                settings.subuse(s),...
                settings.runuse(r),...
                c);
            ff = findFilesBVQX(settings.data_beta_sm,fnsrc);
            if ~isempty(ff)
                load(ff{1});
                [locidx, jointmap] = getLocationsFlat(settings,params,map,map3d,locations,data);
                if s == 1 
                    rawmap = jointmap; 
                else
                    rawmap = rawmap & jointmap; 
                end 
            end
        end
    end
end

end

function [settings, params ] = get_settings_and_parms()
settings.rootdir       = fullfile('..','..','..','MRI_Data_self_other','subjects_3000_study');
settings.vmpdir        = fullfile(settings.rootdir, 'results_multi_smoothed');
settings.vmpfn         = 'vois_all_s-o_vs_rest_multi_smoothed_defined_from_run1_RFX_FDR0001_150_thresh_with_names.vmp';
settings.vmpfn         = 'vois_all_self_other_vs_rest_multi_smoothed_defined_from_run1_Bonforoni_005.vmp';
settings.subuse        = 3000:3022;
settings.runuse        = [2:4];
settings.data_vtc_sm   = fullfile('..','data','raw_flat_vtc_data_smoothed'); % vtc smoothed
settings.data_vtc_nsm  = fullfile('..','data','raw_flat_vtc_data_not_smoothed'); % vtc non smoothed
settings.data_beta_sm  = fullfile('..','data','raw_flat_beta_data_smoothed'); % beta smoothed
settings.resdir        = fullfile('..','results','simalarity_beta_smoothed_partial_voi_small_voi'); % beta smoothed
settings.figdir        = fullfile('..','figures','simalarity_beta_smoothed_partial_voi_small_voi'); % beta smoothed
% set params
params.inputuse        = 'beta_sm'; % 'vtc_sm' , 'vtc_nsm', 'beta_sm';
params.filestr         = 's%d_run%d_cond-%d*.mat'; % subnum, runnun, condnum
params.conds           = {'Ot','Oa','Or','St','Sa','Sr'};
params.pointvtc        = 3; % point used in vtc data selection.
params.voisize         = 50; % sphere size used for voi.
params.compuse         = 'difference'; % type of computation to use for simlariy.
params.getAllVOI       = 1; % if true, get full voi, if false, get only area around voisize
params.avgDistnace     = 1; % if true, compute distance each subject, then average, if false, average data then compute distances 
end

function saveData(data,map,voiname,settings,params,voinum)
resdir = settings.resdir;
mkdir(resdir);
savefn = fullfile(resdir, sprintf('%d_%s.mat',voinum,voiname));
save(savefn,'data','map','voiname','settings','params');
end

function dataout = getDataFromVOI(settings,params,s,map3d,map3dAllSub)
% out data is [voxels x conditions]
for r = 1:length(settings.runuse) % loop on runs 
    for c = 1:length(params.conds) % loop on conditions 
        fnsrc = sprintf(params.filestr,...
            settings.subuse(s),...
            settings.runuse(r),...
            c);
        ff = findFilesBVQX(settings.data_beta_sm,fnsrc);
        if ~isempty(ff)
            load(ff{1});
            if c == 1
                [locidx, jointmap] = getLocationsFlat(settings,params,map3dAllSub,map3d,locations,data);
            end
            % XXX 
            datac(:,c,r) = mean(data(locidx,:),2); % datac is [voxels x conditions x run]
            % its the average beta value across trials.
            % highest beta value within each voi selected per subject,
            % and the 50 closest neighbours selected with euledian
            % distance.
        end
    end
end
% normalize each run: 
for i = 1:size(datac,3);
    datanorm(:,:,i) = bsxfun(@rdivide,datac(:,:,i),std(datac(:,:,i)));
end
dataout = squeeze(mean(datanorm,3)); 
end

function [locidx, jointmap]  = getLocationsFlat(settings,params,maporig,mapvoi,locations,data)
if params.getAllVOI
    % get the locations of the full VOI in flat brain idxs (2d)
    jointmap = logical(maporig) & logical(mapvoi); % in 3d
    jointmapflat = reverseScoringToMatrix1rowAnsMat(jointmap,locations);
    locidx = find(jointmapflat == 1);
else
    % get the flat locations of a sphere arround the highest beta score in the
    % first run of size defines in params
    jointmap = logical(maporig) & logical(mapvoi); % in 3d
    locationsNew = getLocations(jointmap);
    jointmapflat = reverseScoringToMatrix1rowAnsMat(jointmap,locations);
    meandata = mean(data,2);
    idxjointmapflat = find(jointmapflat==1);
    tmp = meandata(idxjointmapflat); % get all voi data
    [betamax, idxmax] = max(tmp);
    idxformax = idxjointmapflat(idxmax);
    idx = knnsearch(locations, locations, 'K', params.voisize); % find searchlight neighbours
    idxVOI = knnsearch(locationsNew, locationsNew, 'K', params.voisize); % find searchlight neighbours
    locationsVOI = locationsNew(idxVOI(idxmax,:),:);
    locationsLinear = sub2ind(size(maporig),locationsVOI(:,1),locationsVOI(:,2),locationsVOI(:,3));
    locationsLinearMapSpace = sub2ind(size(maporig),locations(:,1),locations(:,2),locations(:,3));
    [idxCommon, locidx, ~] = intersect(locationsLinearMapSpace,locationsLinear);
end


end

function D = computeDistance(data,settings,params)
% X=bsxfun(@rdivide,data,std(data));
X = data; 
D = pdist(X','squaredeuclidean');
% sqaureform(1-chi2cdf(D.^2/2,size(X,1)))
% D = pdist(data','squaredeuclidean');
end

function computeMDS(meanD,settings,params)
% MDS
mkdir(settings.figdir);
Y1=mdscale(squareform(meanD),2);
fig_mds = figure('visible','off');
scatter(Y1(:,1),Y1(:,2),1e-2)
text(Y1(:,1),Y1(:,2),params.conds,'fontsize',8)
set(fig_mds,'Color',[1 1 1])
title(strrep(settings.curvoiname,'_',' '));
axis off
figname = sprintf('%d_%s_%s_%s.jpeg',...
    1,...
    'MDS',...
    settings.curvoiname,...
    'squaredeuclidean');
saveas(fig_mds,fullfile(settings.figdir,figname));
close(fig_mds);

end

function computeSimlariry(meanD,settings,params)
1-chi2cdf(meanD,length(params.conds))
fprintf('voi %s has %d squares over 0.90\n',settings.curvoiname,...
    sum(1-chi2cdf(meanD,length(params.conds))>0.9));
% sqaureform(1-chi2cdf(meanD,size(rawdat,2)))
distance_mat = squareform((( meanD- min(meanD) ) / ( max(meanD) - min(meanD) ) ) + 0.5);
fig_sim = figure('visible','off');
imagesc(distance_mat); % used to be simlarity_mat
% caxis([16.39 22.57])
colormap redbluecmap
set(gca,'xtick',1:length(params.conds),'xticklabels', params.conds);
set(gca,'ytick',1:length(params.conds),'yticklabels', params.conds);
set(gcf,'Color',[1 1 1])
title(strrep(settings.curvoiname,'_',' '));
figname = sprintf('%d_%s_%s_%s.jpeg',...
    2,...
    'sim_matrix',...
    settings.curvoiname,...
    'squaredeuclidean');
saveas(fig_sim,fullfile(settings.figdir,figname));
close(fig_sim);
end

function computeDendograms(meanD,settings,params)
fig_tree=figure('visible','off');
tree = linkage(meanD,'complete'); % complete, single 
[H,T,outperm] = dendrogram(tree);
set(gca,'xticklabel',params.conds(outperm));
set(gcf,'Color',[1 1 1]);
title(strrep(settings.curvoiname,'_',' '));
figname = sprintf('%d_%s_%s_%s.jpeg',...
    3,...
    'dendograms',...
    settings.curvoiname,...
    'squaredeuclidean');
saveas(fig_tree,fullfile(settings.figdir,figname));
close(fig_tree);
end

function meanD = averageData(data)
% This function averages data from each subject
% in each condition.
dataraw = [] ;
for i  = 1:size(data,2)
    dataraw(:,:,i) = data{i};
end
meanD = mean(dataraw,3);
end

function meanD = averageDistance(data)
% This function averages data from each subject
% in each condition.
for i  = 1:size(data,2)
    D(i,:) = computeDistance(data{i});
end
meanD = mean(D,1);
end