function plot_group_results(settings,params)
roinams = findFilesBVQX(fullfile(settings.resfolder,settings.grpfolder),...
    ['*' params.avgtype '*.mat'],...
    struct('maxdepth',1));

hfig = figure('visible','off'); % fig for each subject
hfig.Position = get( groot, 'Screensize' );
for j = 1:length(roinams) % loop on rois
    effectivealpha = 0.05/length(roinams); 
    [pn,fn] = fileparts(roinams{j});
    load(roinams{j},'ansmat');
    subplot(3,3,j); hold on;
    histogram(ansmat(2:end));
    scatter(ansmat(1),0,80,'r','filled')
    roinm = strrep(fn(11:end-43),'_',' ');
    if ~isnan(ansmat(1))
        pval = calcPvalVoxelWise(ansmat);
    else
        pval = 99;
    end
    if pval<effectivealpha
         ax = gca;
        ax.Box = 'on';
        ax.LineWidth = 2;
        ax.XColor = 'red';
        ax.YColor = 'red';
    end
    figtitle = sprintf('%s (%.3f)',roinm,pval);
    title(figtitle);
    xlabel('t vals');
    ylabel('count');
    set(gca,'FontSize',10)
end
fnmsv = sprintf('%s_%d_shufs_%d_stlzer_shufs_%s_avg_type.pdf',...
    'group',params.numshufs,params.stlzrshuf,params.avgtype);
mkdir(settings.figfolder); 
fullfnmsv = fullfile(settings.figfolder,fnmsv);
hfig.PaperPositionMode = 'auto';
hfig.Units = 'inches';
hfig.PaperOrientation = 'landscape';
hfig.PaperPosition = [.01 .01 [11 8.5]-0.01];
print(hfig,'-dpdf',fullfnmsv);
close(hfig);


end