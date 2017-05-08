function runAnalysisInfinitePrevelance_cross_validated(varargin)
maxNumCompThreads(1);
cd('..');
addpath(genpath(pwd));
cd('replicability');
[settings,params] = get_settings_params_replicability();

%% This runs Infinite style analyis on anatomical ROIs
%% Of self-other data set
if isempty(varargin)
    roisuse = params.roisuse;
    shufnum = 1;
else
    roisuse = varargin{1};
end

numtrialsuse = 10:5:80;
numtrialsuse = 80;
params.numshufs = 100;
% roisuse = [28 29 48 49 50 51 66 67 110 111 11 14 1]; % XXXX 
%     numtrialsuse = 80; %%%% XXXX %%%%
for r = roisuse % loop on rois
    strtsave = tic;
    cnt = 1;
    for t = numtrialsuse
        for s = 1:length(params.subuse) % loop on subjects
            startex = tic;
            [data, labels, runag] = getDataPerSub(params.subuse(s),r,settings,params);
            %                 [data, labels] = trimdataforprev(data,labels,t);
            % makes sure there is enough trials, else , skips this subject with this num of trials
            if ~isempty(data)
                % loop on cv folds 
                unqruns = unique(runag); 
                for ucv = 1:length(unqruns)
                    data_cv = data(runag == unqruns(ucv),:);
                    % extract zeros from data: 
                    data_cv = data_cv(:,sum(data_cv,1)~=0);
                    labels_cv = labels(runag == unqruns(ucv),:);
                    [~, ansMatSub(ucv,:)] = run_MultiT2013_On_ROI(data_cv,labels_cv,settings,params); %
                end
                fprintf('sub %d roi %d numtrials %d computed in %f\n',...
                    params.subuse(s),r, t, toc(startex));
            end
            % average folds: 
            ansMatAll(s,:) = mean(ansMatSub,1); 
            clear ansMatSub; 
        end
    end
    fnmsave = sprintf('roi_%.3d_inf_prev_cv.mat',r);
    fldrsve = settings.resdir_inf_ss_prev_cv;
    
    save(fullfile(fldrsve,fnmsave),...
        'ansMatAll','settings','params');
    
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
