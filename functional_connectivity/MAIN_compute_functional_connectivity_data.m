function MAIN_compute_functional_connectivity_data()
%This created R_FC_d which is the real matrices (can re run this for smoohted)  
[settings,params] = get_settings_params_fc_data();
load('harvard_atlas_short');
R_FC_d = [] ;
% create real matrices
for d=1:2 % loop on the two conditions. 
    R_FC = [];
    subj=1;
    for file = 1:length(params.subuse)
        start = tic; 
%         data = data'; % data should be [time course x voxels ]
        [data,map,locations] = getDataForFuncConnectivity(settings,params,d,params.subuse(file)) ;
        rois_mean_data = [];
        
        for roi=1:length(ROI_BY_REGIONS)
            roi_number_in_map = find(strcmp(ROI,ROI_BY_REGIONS{roi}));
            roi_locations = getVectorLocationFromMapAtlas(labelsdata,roi_number_in_map);
            roi_i_IXs = [];
            for i=1:size(roi_locations,1)
                roi_i_IXs = [roi_i_IXs; find(locations(:,1)==roi_locations(i,1) & ... 
                                 locations(:,2)==roi_locations(i,2) & ... 
                                 locations(:,3)==roi_locations(i,3))];
            end
            rois_mean_data(roi,:) = mean(data(:,roi_i_IXs),2)';
        end
        counter=1;
        for roi1=1:length(ROI)
            for roi2=roi1+1:length(ROI)
                    [R_corr,P_corr] = computeCorr(rois_mean_data(roi1,:),rois_mean_data(roi2,:),params);
                    FC(subj,counter) = P_corr;
                    R_FC(subj,counter) = R_corr;
                    counter=counter+1;
            end
        end
        subj = subj+1;
        fprintf('finished %d sub of cond %d in %f\n',...
            params.subuse(file),d,toc(start)); 
    end
    R_FC_d(d,:,:) = R_FC;
end
mkdir(settings.resdir);
save(fullfile(settings.resdir,params.fnms),'R_FC_d');
    
end

function [data,map,locations] = getDataForFuncConnectivity(settings,params,condNum,subnum) 
conduse= sprintf('cond%d',condNum);
condsuse = params.(conduse);
runseuse = params.runsuse;
subuse = subnum;
dataout = []; 
% data by trial is [ voxels x trial (in time points) x trial ]. last
% dimension is sized as number of trials, second dimension is the
% size of number of points in each trial

for c = 1:length(condsuse)
    for r = 1:length(runseuse)
        fnmserch = sprintf('s%d_run%d_cond-%d*.mat',...
            subuse,runseuse(r),condsuse(c));
        ff = findFilesBVQX(settings.dataloc,fnmserch);
        if ~isempty(ff)
            load(ff{1});
            dataout = cat(3,dataout,data);
        end
    end
end
numtimepoitns = size(dataout,2); 
numtrial = size(dataout,3); 
databeforetranspsote = reshape(dataout,size(dataout,1),numtimepoitns* numtrial);
data = databeforetranspsote';
% data = data'; % data should be [time course x voxels ]

end

function [R,P] = computeCorr(vec1,vec2,params)
switch params.conntype
    case 'corr'
        [R, P] = corrcoef(vec1,vec2);
        R = R(2); 
        P = P(2); 
    case 'eucled'
        [R] = pdist([vec1;vec2],'euclidean');
        P = 1; % dummy variable 
    case 'seuclidean'
        [R] = pdist([vec1;vec2],'seuclidean');
        P = 1; % dummy variable 
    case 'mahalanobis'
        [R] = pdist([vec1;vec2],'mahalanobis');
        P = 1; % dummy variable 
        
end
end