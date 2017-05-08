function plotMultiTShuffleVariablityInifiniteCenteredOnMedian()
% this function plots multi-t variabily
% At subject and group level
% full trials were used and estimates were not used in this itiration.
% This also tried to estimate the mixture probabtilities checking if they
% are one / not one. 
close all;
load harvard_atlas_short.mat;
rois = 1:111;
filepat = 'roi_%0.3d_shuf_*_inf_prev_80trials.mat';
rootdir = fullfile('..','..','results','Replicability','ss_infinite_prevelance_v2');
figdir = fullfile('..','..','figures','replicability','infinte_variability_shufs_median_centered');

%% agregate data from group prev Ruti: 
rutidir = fullfile('..','..','results','Replicability','group_prevelance_ruti');
subs = 3000:3022;
rois = 1:111;
% % output matrix is subject x shuffels x roi 
% for s = 1:length(subs)
%     for r = 1:length(rois)
%         load(fullfile(rutidir,sprintf('sub_%d_roi_%0.3d',subs(s),rois(r))));
%         alldata(s,:,r) = ansMat; 
%         pvals(s,r) = pval; 
%         clear ansMat pval 
%     end
% end
% save('temp.mat','alldata','pvals');
load('temp.mat'); 

rois = 1:111;
rois = 60;
for r = rois
    hfig = figure;
    hfig.Position = [151         215        1535        1083];
    %% Plot centered median variance within subject 
    subplot(2,2,1)
    % plot box plot
    dataplot = squeeze(alldata(:,2:end,r)');
    mediandataplot = median(dataplot,1);
    dataplotcented = dataplot - mediandataplot;
    realdata = squeeze(alldata(:,1,r)) - mediandataplot'; 
    violin(dataplotcented)
    xlabel('subject #');
    ylabel('Multi T Within Subjects (Perm Median Subtracted)');
    % plot pvals 
    hold all; 
    scatter(1:size(dataplot,2),...
        realdata,...
        40,[1 0 0],'o','filled','MarkerFaceAlpha',0.5);
    centeredPrevForEst(:,1) = realdata; 
    centeredPrevForEst(:,2) = repmat(80,length(realdata),1);
    [percest(r), sig1(r), mucent(r)] = estimate_Prevelane(centeredPrevForEst);
    titletxt = sprintf('%s computed inf prev = %f',...
        'Var in Shuf. W/subs cen. on Median',...
        percest(r));
    title(titletxt);
    %% plot centered median varriance between subjects 
    subplot(2,2,2)
    boxplot(dataplotcented');
    hbox = gca;
    hbox.XTickLabelRotation = 45;
    %         set(gca,'XTickLabel' , hbox.XTickLabel,'FontSize',5);
    %     scatter(1:size(datashufd,2),var(datashufd,1,1))
    title('Var B. Sub. Across Shufs - Centered Median/sub ');
    xlabel('shuffle #');
    ylabel('Multi T  Between Subjects');
    %% plot manhatan plot 
    subplot(2,2,3);
    % compute pvals:
    logpvals  = log10(pvals(:,r).*(-1));
    scatter(1:size(pvals(:,r),1),...
        logpvals,...
        40,[1 0 0],'o','filled','MarkerFaceAlpha',0.5);
    hold on;
    
    % draw 0.01 line
    puse = log10(0.01) * (-1);
    line([0, size(pvals,1)],[puse puse],...
        'LineStyle','--',...
        'Color',[0.2 0.2 0.2],...
        'LineWidth',1.5);
    t = text(17,puse+0.1,'p = 0.01',...
        'FontName','TimesNewRoman',...
        'FontSize',15);
    t(1).FontWeight = 'Bold';
    t(1).Color = [0.2 0.2 0.2];
    % draw 0.05 line
    puse = log10(0.05) * (-1);
    line([0, size(pvals,1)],[puse puse],...
        'LineStyle','--',...
        'Color',[0.4 0.4 0.4],...
        'LineWidth',1.5);
    t= text(17,puse+0.1,'p = 0.05',...
        'FontName','TimesNewRoman',...
        'FontSize',15);
    t(1).FontWeight = 'Bold';
    t(1).Color = [0.4 0.4 0.4];
    
    % draw 0.1 line
    puse = log10(0.1) * (-1);
    line([0, size(pvals,1)],[puse puse],...
        'LineStyle','--',...
        'Color',[0.6 0.6 0.6],...
        'LineWidth',1.5);
    t = text(17,puse+0.1,'p = 0.1',...
        'FontName','TimesNewRoman',...
        'FontSize',15);
    t(1).FontWeight = 'Bold';
    t(1).Color = [0.6 0.6 0.6];
    xlabel('Subject #');
    ylabel('ind. sub. p-values ( -log_1_0 * pval)');
    title('Man. Plot of P-values per subject');
    %% plot minmization function result of estimate preveleance 
    %% save figure 
    suptitle(sprintf('roi %0.3d - label - %s # shuf - %0.3d',r, ROI{r}, size(alldata,2) ));
    figname = sprintf('roi %0.3d',r);
    hfig.PaperPositionMode = 'auto';
    %%
    save_figure(hfig,figname,figdir,'jpeg');
    

end
save(fullfile(rootdir,'all_sub_data_from_400_shufs_ruti.mat'),...
    'pvals','percest','alldata');
return; 




%% so far don't include this 




%% make plot of declinig variance (sep plot);
rois = 1:111;
filepat = 'roi_%0.3d_shuf_*_inf_prev_80trials.mat';
rootdir = fullfile('..','..','results','Replicability','ss_infinite_prevelance_v2');
figdir = fullfile('..','..','figures','replicability','infinte_variability_shufs');
% get subject vector
skip =1;
if ~skip
    numtrialsuse = 10:5:80;
    [settings,params] = get_settings_params_replicability();
    cntsub =1;
    for t = numtrialsuse
        for s = 1:length(params.subuse) % loop on subjects
            startload = tic;
            [data, labels] = getDataPerSub(params.subuse(s),1,settings,params);
            [data, labels] = trimdataforprev(data,labels,t);
            if ~isempty(data)
                subsvec(cntsub) = params.subuse(s);
                cntsub = cntsub + 1;
            end
            clear data;
            fprintf('finished sub %d num trial %d in %f\n',...
                params.subuse(s),...
                t,...
                toc(startload));
        end
    end
    subsvec = subsvec';
    save('subsvec.mat','subsvec');
else
    load('subsvec.mat','subsvec');
end
[settings,params] = get_settings_params_replicability();
for r = rois
    filepatvar = sprintf('roi_%0.3d_shuf_*_inf_prev_alltrials.mat',r);
    ff = findFilesBVQX(rootdir,sprintf(filepatvar,r));
    if ~isempty(ff)
        for f = 1:length(ff)
            load(ff{f});
            for t = 1:length(numtrialsuse)
                for s = 1:length(params.subuse)
                    logidx = dataprev(:,2) == numtrialsuse(t) & subsvec == params.subuse(s) ;
                    if sum(logidx)
                        dataout(s,t,f) = dataprev(logidx,1);
                    else
                        dataout(s,t,f) = NaN;
                    end
                end
            end
            %             reshape(dataprev(:,2),...
            %                 length(unique(dataprev(:,2))),....
            %                 sum(dataprev(:,2)==10))
        end
        
        % variance within subjects
        varbysub = nanvar(dataout,1,3);
        hfig = figure;
        hfig.Position = [538         684        1589         654] ;
        subplot(1,2,1);
        hplot = plot(numtrialsuse,varbysub,'LineWidth',2);
        legendCell = cellstr(num2str(params.subuse', 's%-d'));
        legend(legendCell)
        title('Variance Across Shuffels Within Subjects');
        xlabel('Number of Trials');
        ylabel('Variance in Multi-T score');
        % variance between subjects
        subplot(1,2,2);
        meanshufPerSub = nanmean(dataout,3);
        avgs = nanmean(meanshufPerSub,1);
        varsBetSubs = nanstd(meanshufPerSub,1,1);
        hpatch = patch([numtrialsuse fliplr(numtrialsuse)],...
            [avgs+varsBetSubs fliplr(avgs-varsBetSubs)],[0.7 0.7 0.7]);
        hpatch.FaceAlpha = 0.5;
        hold on;
        hplot = plot(numtrialsuse,avgs);
        hplot.LineWidth = 3;
        xlabel('Number of Trials')
        ylabel('Blue Line- avg. across shuffle and subs, grey- std across subject avgs'); 
        title('Variance Between Subjects Across Averaged Shuffels Per Subject');
        
        %% save figure
        suptitle(sprintf('roi %0.3d - label - %s # shuf - %0.3d',r, ROI{r}, length(ff)));
        figname = sprintf('roi %0.3d across trials',r);
        hfig.PaperPositionMode = 'auto';
        %%
        save_figure(hfig,figname,figdir,'jpeg');
        clear datashufd ff percout perc
    end
end

end