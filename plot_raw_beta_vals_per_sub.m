function plot_raw_beta_vals_per_sub(settings,params)
% subdirs = findFilesBVQX(settings.resfolder,[settings.subpref '*'],...
%         struct('dirs',1,'maxdepth',1));

%% plot raw beta values 
for j = 1:length(settings.experconds) % loop on experiment 
    rawbetafn = findFilesBVQX(...
        fullfile(settings.datadir,settings.experconds{j}),...
        [settings.datafileprefix '*.mat'],...
        struct('maxdepth',1));
    hfig = figure('visible','off'); % fig for each subject
    hfig.Position = [0 0 1e3 1e3];
    for k = 1:length(rawbetafn) % loop on subjects 
        start = tic; 
        load(rawbetafn{k});
        [pn,fn] = fileparts(rawbetafn{k});
        subplot(3,4,k);
        nh = ndhist(mean(data(labels==1,:),1),mean(data(labels==2,:),1),...
            'filter','log','logplot'); 
        xlims = get(gca,'xlim'); ylims = get(gca,'ylim');
        minval = min([xlims ylims]); maxval = max([xlims ylims]);
        set(gca,'xlim',[minval maxval]);
        set(gca,'ylim',[minval maxval]);
        nh = ndhist(mean(data(labels==1,:),1),mean(data(labels==2,:),1),...
            'filter','log','logplot',...
            'axis',[minval maxval minval maxval]);
        set(gca,'FontSize',7)
        fprintf('%s %s in %f secs\n',...
            settings.experconds{j},fn,toc(start));
    end
    suptitle('raw beta vals all subs'); 
    % print results 
    fnmsv = sprintf('raw_beta_vals_all_subs_heatmaps_%s.pdf',settings.experconds{j});
    fold2save = fullfile('..',settings.figfold,settings.experconds{j}); 
    fullfnmsv = fullfile(fold2save,fnmsv);
    hfig.PaperPositionMode = 'auto'; 
    hfig.Units = 'inches'; 
    hfig.PaperOrientation = 'landscape';
    hfig.PaperPosition = [.01 .01 [11 8.5]-0.01];
    print(hfig,'-dpdf',fullfnmsv,'-opengl');
    close(hfig);
end

%% plot raw beta heat maps values 

for j = 1:length(settings.experconds) % loop on experiment 
    rawbetafn = findFilesBVQX(...
        fullfile(settings.datadir,settings.experconds{j}),...
        [settings.datafileprefix '*.mat'],...
        struct('maxdepth',1));
    hfig = figure('visible','off'); % fig for each subject
    hfig.Position = [0 0 1e3 1e3];
    for k = 1:length(rawbetafn) % loop on subjects 
        start = tic; 
        load(rawbetafn{k});
        [pn,fn] = fileparts(rawbetafn{k});
        subplot(3,4,k);
        nh = ndhist(mean(data(labels==1,:),1),mean(data(labels==2,:),1),...
            'filter','log','logplot','max'); 
        xlims = get(gca,'xlim'); ylims = get(gca,'ylim');
        minval = min([xlims ylims]); maxval = max([xlims ylims]);
        set(gca,'xlim',[minval maxval]);
        set(gca,'ylim',[minval maxval]);
        nh = ndhist(mean(data(labels==1,:),1),mean(data(labels==2,:),1),...
            'filter','log','logplot','max',...
            'axis',[minval maxval minval maxval]);
        set(gca,'FontSize',7)
        fprintf('%s %s in %f secs\n',...
            settings.experconds{j},fn,toc(start));
    end
    suptitle('raw beta vals all subs'); 
    % print results 
    fnmsv = sprintf('raw_beta_vals_all_subs_heatmaps_max_%s.pdf',settings.experconds{j});
    fold2save = fullfile('..',settings.figfold,settings.experconds{j}); 
    fullfnmsv = fullfile(fold2save,fnmsv);
    hfig.PaperPositionMode = 'auto'; 
    hfig.Units = 'inches'; 
    hfig.PaperOrientation = 'landscape';
    hfig.PaperPosition = [.01 .01 [11 8.5]-0.01];
    print(hfig,'-dpdf',fullfnmsv,'-opengl');
    close(hfig);
end
%% plot scatter plot 
%{
for j = 1:length(settings.experconds) % loop on experiment 
    rawbetafn = findFilesBVQX(...
        fullfile(settings.datadir,settings.experconds{j}),...
        [settings.datafileprefix '*.mat'],...
        struct('maxdepth',1));
    hfig = figure('visible','off'); % fig for each subject
    hfig.Position = get( groot, 'Screensize' );
    for k = 1:length(rawbetafn) % loop on subjects 
        start = tic; 
        load(rawbetafn{k});
        [pn,fn] = fileparts(rawbetafn{k});
        subplot(3,4,k);
        x = nanmedian(data(labels==1,:),1); 
        y = nanmedian(data(labels==2,:),1);
        scatter(x,y);
        % plot figure 
        xlabel('raw data x')
        ylabel('raw data y'); 
        title(sprintf('%s',fn));
        set(gca,'FontSize',7)
        axis equal 
        axis square 
        pause(0.1);
        drawXandEqualityLine()
        fprintf('%s %s in %f secs\n',...
            settings.experconds{j},fn,toc(start));
    end
    suptitle('raw beta vals cond a vs b scatter pltos'); 
    % print results 
    fnmsv = sprintf('raw_beta_vals_all_subs_scatter_%s.pdf',settings.experconds{j});
    fold2save = fullfile('..',settings.figfold,settings.experconds{j}); 
    fullfnmsv = fullfile(fold2save,fnmsv);
    hfig.PaperPositionMode = 'auto'; 
    hfig.Units = 'inches'; 
    hfig.PaperOrientation = 'landscape';
    hfig.PaperPosition = [.01 .01 [11 8.5]-0.01];
    print(hfig,'-dpdf',fullfnmsv,'-opengl');
    close(hfig);
end
%}

end