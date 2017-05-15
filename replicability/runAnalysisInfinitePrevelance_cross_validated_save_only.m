function runAnalysisInfinitePrevelance_cross_validated_save_only(varargin)
maxNumCompThreads(1);
cd('..');
addpath(genpath(pwd));
cd('replicability');
[settings,params] = get_settings_params_replicability();
load harvard_atlas_short.mat;
rois = 1:111;


%% This runs Infinite style analyis on anatomical ROIs
%% Of self-other data set
if isempty(varargin)
    roisuse = params.roisuse;
    shufnum = 1;
else
    roisuse = varargin{1};
end
%% open file to write 
fnmsave = sprintf('roi-%0.3d_label-%s.csv',roisuse, ROI{roisuse});
settings.writedir = fullfile(settings.resdir_root,'CV_multit_csv_dat_forInfi_reg');
mkdir(settings.writedir); 
fullfnm = fullfile(settings.writedir, fnmsave); 
fid = fopen(fullfnm,'w+'); 

numtrialsuse = 2:1:21;
% numtrialsuse = 80;
params.numshufs = 0;
%     numtrialsuse = 80; %%%% XXXX %%%%
fprintf(fid,'numtrial,subject,multi-t average across folds,cv1,cv2,cv3,cv4\n'); 
for r = roisuse % loop on rois
    strtsave = tic;
    cnt = 1;
    for t = numtrialsuse
        for s = 1:length(params.subuse) % loop on subjects
            startex = tic;
            [data, labels, runag] = getDataPerSub(params.subuse(s),r,settings,params);
            % makes sure there is enough trials, else , skips this subject with this num of trials
            if ~isempty(data)
                % loop on cv folds 
                unqruns = unique(runag); 
                for ucv = 1:length(unqruns)
                    data_cv = data(runag == unqruns(ucv),:);
                    % extract zeros from data: 
                    data_cv = data_cv(:,sum(data_cv,1)~=0);
                    labels_cv = labels(runag == unqruns(ucv),:);
                    [data_cv, labels_cv] = trimdataforprev(data_cv,labels_cv,t);
                    [~, ansMatSub(ucv,:)] = run_MultiT2013_On_ROI(data_cv,labels_cv,settings,params); %
                end
                fprintf(fid,'%d,%d,%f,',t,params.subuse(s),mean(ansMatSub)); 
                for cvf = 1:length(ansMatSub)
                    fprintf(fid,'%f,',ansMatSub(cvf));
                end
                fprintf(fid,'\n'); 
                clear ansMatSub; 
                fprintf('sub %d roi %d numtrials %d computed in %f\n',...
                    params.subuse(s),r, t, toc(startex));
            end
        end
    end
%     fnmsave = sprintf('roi_%.3d_inf_prev_cv.mat',r);
%     fldrsve = settings.resdir_inf_ss_prev_cv;
    
%     save(fullfile(fldrsve,fnmsave),...
%         'ansMatAll','settings','params');
    
    %% compute inf prevelance
%     perc = estimate_Prevelane(dataprev);
%     save(fullfile(fldrsve,fnmsave),...
%         'perc','dataprev','numtrialsuse','settings','params');
%     
%     fprintf('roi %d saved in \t %f secs\n',...
%         r,toc(strtsave));
%     fprintf('\n\n');
end


end
