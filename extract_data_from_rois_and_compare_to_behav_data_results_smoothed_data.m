[settings, params] = getparams();
load(fullfile(settings.resfold,'behav_results_catch_trials.mat'),'results'); 
beahvaccpersub = results.accofrsp';


rootdir = 'D:\Roee_Main_Folder\1_AnalysisFiles\MRI_Data_self_otherv3\MRI_data\SubjectsData\subjects_3000_study\';
subdirs = findFilesBVQX(rootdir,'3*',struct('dirs',1,'depth',1));
% get atd unique filenames 
% unique rois 
unqrois = {'SMA_bilateral' 'Prefrontal_R' 'SPL_R' 'SPL_L' 'visual_L' 'visual_R'};
unqcond = {'subject','catch_trial' 'other_Traklin' 'other_arnoit' 'other_rashamkol' 'self_Traklin' 'self_arnoit' 'self_rashamkol'};
% loop on rois names and get data from atd's for each subject 
for i = 1:length(unqrois) % loop on rois 
    for j = 1:length(subdirs) % loop subs 
        fldnm = fullfile(subdirs{j},'functional','results_smoothed');
        atdfnm = findFilesBVQX(fldnm,[ '*' unqrois{i} '*.atd']);
        [pn,fn] = fileparts(atdfnm{1});
        fprintf('%s\n',fn);
        rawdata = importdata(atdfnm{1},'\t',9);
        rawtext = regexp(rawdata{9},'[0-9]+.[0-9]+','match');
        for k = 1:length(unqcond) % loop on conditions 
            data.(unqrois{i}).(unqcond{k})(j,1) = str2num(rawtext{k});
        end
    end
end
fold2save = fullfile('..',settings.figfold,'smoothings_individ_rois');

%% plot self / other box plot 
hfig = figure('Visible','On'); 
hfig.Position = [-1381         149        1287         812];
idxself = 3:5; idxothr = 6:8;
for i = 1:length(unqrois)
    tbl = struct2table(data.(unqrois{i}));
    subplot(2,3,i);
    selfmean = mean(tbl{:,idxself},2);
    othrmean = mean(tbl{:,idxothr},2);
    hbox = boxplot([selfmean,othrmean]);
    set(gca,'XTickLabel',{'self','other'});
    [h,p] = ttest(selfmean,othrmean); 
    ttlstr = sprintf('%s (p = %.3f)',unqrois{i},p);
    title(ttlstr); 
    ylabel('beta value'); 
    if p<=0.05/6
        ax = gca;
        ax.Box = 'on';
        ax.LineWidth = 4;
        ax.XColor = 'red';
        ax.YColor = 'red';
    end
end
fnmsv = sprintf('rois_smoothed_invidid_self_vs_other.pdf');
printfig(fold2save,fnmsv,hfig); close(hfig); 

%% plot self other box plots by word 
hfig = figure('Visible','On'); 
hfig.Position = [-1381         149        1287         812];
idxorder = [3 6 4 7 5 8]; 
idxlabels = {'Otr_T', 'Slf_T', 'Otr_A', 'Slf_A','Otr_R', 'Slf_R',};
idxself = 3:5; idxothr = 6:8;
for i = 1:length(unqrois)
    tbl = struct2table(data.(unqrois{i}));
    subplot(2,3,i);
    hbox = boxplot(tbl{:,idxorder});
    set(gca,'XTickLabel',idxlabels);
%     [h,p] = ttest(selfmean,othrmean); 
    ttlstr = sprintf('%s ',unqrois{i});
    title(ttlstr); 
    ylabel('beta value'); 
%     if p<=0.05/6
%         ax = gca;
%         ax.Box = 'on';
%         ax.LineWidth = 4;
%         ax.XColor = 'red';
%         ax.YColor = 'red';
%     end
end
fnmsv = sprintf('rois_smoothed_invidid_self_vs_other_split_by_word.pdf');
printfig(fold2save,fnmsv,hfig); close(hfig); 


%% plot words box plots 
hfig = figure('Visible','On'); 
hfig.Position = [-1381         149        1287         812];
idx_traklin = [3 6]; idx_aronit = [4 7]; idx_rashamkol = [5 8];
idxlabels = {'traklin', 'aronit', 'rashamkol'};
for i = 1:length(unqrois)
    tbl = struct2table(data.(unqrois{i}));
    subplot(2,3,i);
    wrd1 = mean(tbl{:,idx_traklin},2);
    wrd2 = mean(tbl{:,idx_aronit},2);
    wrd3 = mean(tbl{:,idx_rashamkol},2);
    hbox = boxplot([wrd1,wrd2,wrd3]);
    set(gca,'XTickLabel',idxlabels);
%     [h,p] = ttest(selfmean,othrmean); 
%     ttlstr = sprintf('%s (p = %.3f)',unqrois{i},p);
    ttlstr = sprintf('%s (p = %.3f)',unqrois{i});
    title(ttlstr); 
    ylabel('beta value'); 
%     if p<=0.05/6
%         ax = gca;
%         ax.Box = 'on';
%         ax.LineWidth = 4;
%         ax.XColor = 'red';
%         ax.YColor = 'red';
%     end
end
fnmsv = sprintf('rois_smoothed_invidid_words.pdf');
printfig(fold2save,fnmsv,hfig); close(hfig); 

%% plot correlation with behaviour box plot collapsed on self/other

%% plot correlation with beahvour box plots collapsed on specific self / other words 

%% plot correeation with behavour 

hdrrow = 8; 
idxavg = 2:4;
idxsub = 1:12;
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
    
    %% plot scatter plot of behav and roi 
    corrval(i) = corr(mean(betadata(idxsub,idxavg),2),beahvaccpersub(idxsub));
    tmp = corrcoef([mean(betadata(:,idxavg),2),beahvaccpersub],'rows','pairwise');
    corrval2(i) = tmp(1,2);
    fprintf('%s\t\t\t\t\t %.3f \n',roiname,corrval(i));
    % 
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