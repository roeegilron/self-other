function runAnalysisInfinitePrevelance(varargin)
cd('..'); 
addpath(genpath(pwd)); 
cd('replicability');
[settings,params] = get_settings_params_replicability();

%% This runs Infinite style analyis on anatomical ROIs
%% Of self-other data set
if isempty(varargin)
    roisuse = params.roisuse;
else
    roisuse = varargin{1}; 
end

numtrialsuse = 1:5:10;
for r = roisuse% loop on rois
    strtsave = tic;
    cnt = 1;
    for t = numtrialsuse
        for s = 1:length(params.subuse) % loop on subjects
            startex = tic; 
            [data, labels] = getDataPerSub(params.subuse(s),r,settings,params);
            [data, labels] = trimdataforprev(data,labels,t);
            params.numshufs = 1; % bcs we don't care about shuffels for now 
            [pval, ansMat] = run_MultiT2013_On_ROI(data,labels,settings,params); % for ruti
            dataprev(cnt,1) = ansMat(1); 
            dataprev(cnt,2) = t; 
            cnt = cnt + 1; 
            fprintf('sub %d roi %d numtrials %d computed in %f\n',...
                params.subuse(s),r, t, toc(startex)); 
        end
    end
    perc = estimate_Prevelane(dataprev);
    fnmsave = sprintf('roi_%.3d_inf_prev.mat',r);
    fldrsve = settings.resdir_inf_ss_prev;
    save(fullfile(fldrsve,fnmsave),...
        'perc','dataprev','numtrialsuse','settings','params');
    
    fprintf('roi %d saved in \t %f secs\n',...
        r,toc(strtsave));
    fprintf('\n\n');
end

end