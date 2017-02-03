function plotDataInfinitePrevelance()
[settings,params ] = get_settings_params_replicability;

% loop on ROI's
load('harvard_atlas_short.mat');
rois = 1:111;
subjects = 1:23;
% get max multi-t value
for r = 1:length(rois)
    fn = sprintf('roi_%0.3d_inf_prev.mat',rois(r));
    try
        load(fullfile(settings.resdir_inf_ss_prev,fn));
        maxt(r) = max(dataprev(:,1)); 
    catch
        fprintf('roi %0.3d does not exist\n',rois(r));
    end
end


maxtt = max(maxt); 
%% box plots 
skipthis = 1; 
if ~skipthis 
for r = 1:length(rois)
    fn = sprintf('roi_%0.3d_inf_prev.mat',rois(r));
    try
        load(fullfile(settings.resdir_inf_ss_prev,fn));
        figname = sprintf('box-plots-across-subs_-%0.3d',rois(r));
        figdir  = fullfile('..','..','figures', 'replicability','infinite');
        hfig = figure('visible','off');
        boxplot(dataprev(:,1),dataprev(:,2));
        ylim([0 maxtt]); 
        ttlstr = sprintf('ROI %0.3d (%s)',rois(r),ROI{r});
        % set titels and get handels
        htitle = title(ttlstr);
        htitle.FontSize = 15;
        xtitle = 'Number of trials';
        ytitle = 'Muni-Meng Value';
        hxlabel = xlabel(xtitle);
        hxlabel.FontSize = 14;
        hylabel = ylabel(ytitle);
        hylabel.FontSize = 14;
        save_figure(hfig,figname,figdir,'jpeg')
    catch
        fprintf('roi %0.3d does not exist\n',rois(r));
        %% regular plots
    end
end
end

%% line plots 
skipthis = 1; 
if ~skipthis 
for i = 1:length(numtrialsuse)
    fprintf('%d subs in %d trials\n',sum(dataprev(:,2)==numtrialsuse(i)),numtrialsuse(i));
end
for r = 1:length(rois)
    fn = sprintf('roi_%0.3d_inf_prev.mat',rois(r));
    try
        load(fullfile(settings.resdir_inf_ss_prev,fn));
        figname = sprintf('line-plots-across-subs_-%0.3d',rois(r));
        figdir  = fullfile('..','..','figures', 'replicability','infinite');
        hfig = figure('visible','on');
        for i = 1:length(numtrialsuse)
            avgs(i) = mean(dataprev(dataprev(:,2)==numtrialsuse(i),1));
            stdvs(i)  = std(dataprev(dataprev(:,2)==numtrialsuse(i),1));
        end
        hold on; 
        ttlstr = sprintf('ROI %0.3d (%s)',rois(r),ROI{r});
        hpatch = patch([numtrialsuse fliplr(numtrialsuse)],...
            [avgs+stdvs fliplr(avgs-stdvs)],[0.7 0.7 0.7]);
        hpatch.FaceAlpha = 0.5;
        hplot = plot(numtrialsuse,avgs);
        hplot.LineWidth = 3;
        ylim([0 maxtt]);
        % set titels and get handels
        htitle = title(ttlstr);
        htitle.FontSize = 15;
        xtitle = 'Number of trials';
        ytitle = 'Muni-Meng Value';
        hxlabel = xlabel(xtitle);
        hxlabel.FontSize = 14;
        hylabel = ylabel(ytitle);
        hylabel.FontSize = 14;
        save_figure(hfig,figname,figdir,'jpeg')
    catch
        fprintf('roi %0.3d does not exist\n',rois(r));
        %% regular plots
    end
end
end

%% line pltos per subject 
rois = [110 111]; 
for i = 1:length(numtrialsuse)
    fprintf('%d subs in %d trials\n',sum(dataprev(:,2)==numtrialsuse(i)),numtrialsuse(i));
end
for r = 1:length(rois)
    fn = sprintf('roi_%0.3d_inf_prev.mat',rois(r));
    try
        load(fullfile(settings.resdir_inf_ss_prev,fn));
        figname = sprintf('llline-plots-within-subs_-%0.3d',rois(r));
        figdir  = fullfile('..','..','figures', 'replicability','infinite');
        hfig = figure('visible','on');
        hold on 
        for i = 1:11 % past a certain number of trial not all subs have this 
            datprevbysub(:,i) = dataprev(dataprev(:,2)==numtrialsuse(i),1);
%             avgs(i) = mean(dataprev(dataprev(:,2)==numtrialsuse(i),1));
%             stdvs(i)  = std(dataprev(dataprev(:,2)==numtrialsuse(i),1));
        end
        for i = 1:23
        subs{i} = sprintf('sub %0.3d',i); 
        end
        for i = 1:size(datprevbysub,1) 
            hplot = plot(numtrialsuse(1:11),datprevbysub(i,:));
            hplot.LineWidth = 3;
        end
        hleg = legend(subs); 
        hleg.Location = 'northeastoutside';
        ttlstr = sprintf('ROI %0.3d (%s)',rois(r),ROI{rois(r)});
%         hpatch = patch([numtrialsuse fliplr(numtrialsuse)],...
%             [avgs+stdvs fliplr(avgs-stdvs)],[0.7 0.7 0.7]);
%         hpatch.FaceAlpha = 0.5;
        ylim([0 maxtt]);
        % set titels and get handels
        htitle = title(ttlstr);
        htitle.FontSize = 15;
        xtitle = 'Number of trials';
        ytitle = 'Muni-Meng Value';
        hxlabel = xlabel(xtitle);
        hxlabel.FontSize = 14;
        hylabel = ylabel(ytitle);
        hylabel.FontSize = 14;
        save_figure(hfig,figname,figdir,'jpeg')
    catch
        fprintf('roi %0.3d does not exist\n',rois(r));
        %% regular plots
    end
end