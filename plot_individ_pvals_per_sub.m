function plot_individ_pvals_per_sub(settings,params)
for j = 1:length(settings.experconds) % loop on experiment
    % find folders of results analysis within reuslts
    resfolders = findFilesBVQX(...
        fullfile(settings.resfold,settings.experconds{j}),...
        ['*' settings.experconds{j} '*'],...
        struct('dirs',1,'maxdepth',1));
    for m = 1:length(resfolders)
        rawmtres = findFilesBVQX(...
            resfolders{m},...
            [settings.resfileprefix '*.mat'],...
            struct('maxdepth',1));
        hfig = figure('visible','off'); % fig for each subject
        hfig.Position = get( groot, 'Screensize' );
        for k = 1:length(rawmtres) % loop on subjects
            start = tic;
            load(rawmtres{k},'ansMat','locations');
            [pn,fn] = fileparts(rawmtres{k});
            subplot(3,4,k);
            % plot figure
            ansMat = fixAnsMat(ansMat,locations,'min');
            pval = calcPvalVoxelWise(squeeze(ansMat(:,:,1)));
            histogram(pval);
            xlabel('pvalues')
            ylabel('count');
            subname = regexp(fn,'sub_[0-9]+','match');
            title(sprintf('%s',subname{1}));
            set(gca,'FontSize',7)
            fprintf('%s %s in %f secs\n',...
                settings.experconds{j},subname{1},toc(start));
        end
        % get elmentes to save filename 
        suptitle('raw pvals all subs');
        slsize = regexp(fn,'SL[0-9]+','match');
        numshuf = regexp(fn,'[0-9]+shuf+','match');
        % print results
        fnmsv = sprintf('pval_individ_subs_%s_%s_%s_.pdf',...
            slsize{1},...
            numshuf{1},...
            settings.experconds{j});
        fold2save = fullfile('..',settings.figfold,settings.experconds{j});
        fullfnmsv = fullfile(fold2save,fnmsv);
        hfig.PaperPositionMode = 'auto';
        hfig.Units = 'inches';
        hfig.PaperOrientation = 'landscape';
        hfig.PaperPosition = [.01 .01 [11 8.5]-0.01];
        print(hfig,'-dpdf',fullfnmsv,'-opengl');
        close(hfig);
    end
end
end