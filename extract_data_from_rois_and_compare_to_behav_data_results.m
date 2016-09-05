[settings, params] = getparams();
load(fullfile(settings.resfold,'behav_results_catch_trials.mat'),'results'); 
beahvaccpersub = results.accofrsp';


rootdir = 'D:\Roee_Main_Folder\1_AnalysisFiles\MRI_Data_self_otherv3\MRI_data\SubjectsData\subjects_3000_study\results_multi_smoothed\atd_files_per_voi';
atdfnms = findFilesBVQX(rootdir,'*.atd');
hdrrow = 8; 
idxavg = 2:4;
idxsub = 1:12;
clc
hfig = figure('Visible','On'); 
hfig.Position = [-1381         149        1287         812];
for i = 1:length(atdfnms)
    rawdata = importdata(atdfnms{i},'\t',21); 
    [pn , roiname] = fileparts(atdfnms{i});
%     hrds = rawdata{j};
    cnt = 1; betadata = []; 
    for j = hdrrow+1:length(rawdata);
        rawtext = regexp(rawdata{j},'[0-9]+.[0-9]+','match');
        subs(cnt) = str2num(rawtext{1});
        for k = 2:length(rawtext)
            betadata(cnt,k-1) = str2num(rawtext{k});
        end
        cnt = cnt + 1;
    end
    corrval(i) = corr(mean(betadata(idxsub,idxavg),2),beahvaccpersub(idxsub));
    tmp = corrcoef([mean(betadata(:,idxavg),2),beahvaccpersub],'rows','pairwise');
    corrval2(i) = tmp(1,2);
    fprintf('%s\t\t\t\t\t %.3f \n',roiname,corrval(i));
    %% plot scatter plot of behav and roi 
    subplot(3,3,i); 
    scatter(mean(betadata(idxsub,idxavg),2),beahvaccpersub(idxsub)); 
    xlabel('beta val'); 
    ylabel('behav acc'); 
    roinameprint = roiname(regexp(roiname,'VOI-','end')+1:regexp(roiname,'all_subs','start')-1);
    resultscorr(i).roiname = roinameprint;
    resultscorr(i).betadata = betadata;
    ttlstr = sprintf('%s (r = %.3f)',roinameprint, corrval(i));
    title(ttlstr); 
end
% print results
fnmsv = sprintf('scatter_plots_behav_results_vs_rois_smoothed.pdf');
fold2save = fullfile('..',settings.figfold);
fullfnmsv = fullfile(fold2save,fnmsv);
hfig.PaperPositionMode = 'auto';
hfig.Units = 'inches';
hfig.PaperOrientation = 'landscape';
hfig.PaperPosition = [.01 .01 [11 8.5]-0.01];
print(hfig,'-dpdf',fullfnmsv,'-opengl');
close(hfig);

%% plot bar graph of self vs other and t test 
idxself = 2:4; idxother = 5:7; 
hfig = figure('Visible','On'); 
hfig.Position = [-1381         149        1287         812];
for i = 1:length(resultscorr)
    subplot(3,3,i); 
    selfmean = mean(resultscorr(i).betadata(:,idxself),2);
    othrmean = mean(resultscorr(i).betadata(:,idxother),2);
    hbox = boxplot([selfmean,othrmean]);
    set(gca,'XTickLabel',{'self','other'});
    [h,p] = ttest(selfmean,othrmean); 
    ttlstr = sprintf('%s (p = %.3f)',resultscorr(i).roiname,p*length(resultscorr));
    title(ttlstr); 
end
fnmsv = sprintf('box_plots_behav_results_vs_rois_smoothed.pdf');
fold2save = fullfile('..',settings.figfold);
fullfnmsv = fullfile(fold2save,fnmsv);
hfig.PaperPositionMode = 'auto';
hfig.Units = 'inches';
hfig.PaperOrientation = 'landscape';
hfig.PaperPosition = [.01 .01 [11 8.5]-0.01];
print(hfig,'-dpdf',fullfnmsv,'-opengl');
close(hfig);