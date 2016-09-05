function plotsinglesubresults(settings,params)
subdirs = findFilesBVQX(settings.resfolder,[ '3*'],...
    struct('dirs',1,'maxdepth',1));

for i = 1:length(subdirs)% loop on subs 
    roifnms = findFilesBVQX(subdirs{i},'*.mat');
    hfig = figure('visible','off'); % fig for each subject 
    hfig.Position = get( groot, 'Screensize' );
    effectivealpha = 0.05/length(roifnms);
    for j = 1:length(roifnms) % loop on rois 
        [pn,fn] = fileparts(roifnms{j});
        load(roifnms{j},'ansmat');
        subplot(3,3,j); hold on; 
        histogram(ansmat(2:end),50);
        scatter(ansmat(1),0,80,'r','filled')
        roinm = fn(5:end);
        if ~isnan(ansmat(1))
            pval = calcPvalVoxelWise(ansmat);
        else
            pval = 99;
        end
        if pval < effectivealpha
            ax = gca;
            ax.Box = 'on';
            ax.LineWidth = 2;
            ax.XColor = 'red';
            ax.YColor = 'red';
        end
        figtitle = sprintf('%s (%.3f)',strrep(roinm,'_',' '),pval); 
        title(figtitle); 
        xlabel('t vals');
        ylabel('count');
        set(gca,'FontSize',10)
    end
    [pn,subnm] = fileparts(pn);
    suptitle(sprintf('sub %s',subnm));
    fnmsv = sprintf('%s.pdf',subnm);
    mkdir(settings.figfolder); 
    fullfnmsv = fullfile(settings.figfolder,fnmsv);
    hfig.PaperPositionMode = 'auto'; 
    hfig.Units = 'inches'; 
    hfig.PaperOrientation = 'landscape';
    hfig.PaperPosition = [.01 .01 [11 8.5]-0.01];
    print(hfig,'-dpdf',fullfnmsv);
    close(hfig);
end

end