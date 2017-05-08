function MAIN_cross_validated_Multit_infinite_prevelance()


maxNumCompThreads(1);
cd('..');
addpath(genpath(pwd));
cd('replicability');
[settings,params] = get_settings_params_replicability();

%% This runs Infinite style analyis on anatomical ROIs


numtrialsuse = 10:5:80;
numtrialsuse = 80;
roisuse = 1:111; % XXX 
for ss = 1
    shufnum = ss; 
%     numtrialsuse = 80; %%%% XXXX %%%%
    for r = roisuse% loop on rois
        strtsave = tic;
        cnt = 1;
        for t = numtrialsuse
            for s = 1:length(params.subuse) % loop on subjects
                startex = tic;
                [data, labels, runag] = getDataPerSub(params.subuse(s),r,settings,params);
                % CV1 
                data_cv1 = data(runag<3,:);
                labels_cv1 = labels(runag<3,:);
                x = data_cv1(labels_cv1==1,:);
                y = data_cv1(labels_cv1==2,:);
                
                % CV2
                data_cv2 = data(runag>2,:);
                labels_cv2 = labels(runag>2,:);
                x1 = data_cv2(labels_cv2==1,:);
                y1 = data_cv2(labels_cv2==2,:);
                
                tstat = calcTstatMuniMengTwoGroup_cross_validated(x,y,x1,y1);
                dataprev(cnt,1) = tstat;
                dataprev(cnt,2) = numtrialsuse;
                cnt = cnt +1 ;
            end
        end
    end
    [perc(r), sig1, sig4, mu] = estimate_Prevelane2(dataprev);
    clear dataprev; 
end
save('temp_prev_cv.mat','perc');
end