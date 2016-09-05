function plot_pvals_from_all_second_level_tests(settings,params)
load(fullfile(settings.resfold,'pvals_from_all_tests.mat'),...
    'mask','locations','pvaltoplot','pvaltoplotnames','pvaltoplotfoldnames');

hfig = figure('visible','off'); % fig for each subject
hfig.Position = get( groot, 'Screensize' );
for i =  1:size(pvaltoplot,2)
    subplot(3,4,i); 
    histogram(pvaltoplot(:,i))
    xlabel('pval')
    ylabel('count')
    ylimvals = get(gca,'ylim');
%     text(0.1,ylimvals(2)*0.95,fn,'FontSize',4)
%     text(0.1,ylimvals(2)*0.85,fldrnm,'FontSize',4)
    % set fig titls 
    fn = pvaltoplotnames{i};
    [pn,fldrnm ] = fileparts(pvaltoplotfoldnames{i});
    slsize = regexp(fn,'[0-9]+-slsze','match');
    numsubs = regexp(fn,'[0-9]+-subs','match');
    numshufs = regexp(fn,'[0-9]+-stlz','match');
    expcond = regexp(fldrnm(7:end),'s_[a-z]+_','match');
    ttlstr = sprintf('%s %s %s %s',...
        expcond{1}, slsize{1} , numsubs{1}, numshufs{1});
    title(['\fontsize{6}' ttlstr]);
    set(gca,'FontSize',6);
end
suptitle('pvals second level'); 
fold2save = fullfile('..',settings.figfold);
fnmsv = 'second_level_pvalues'; 
fullfnmsv = fullfile(fold2save,fnmsv);
hfig.Units = 'inches';
hfig.PaperOrientation = 'landscape';
hfig.PaperPosition = [.01 .01 [11 8.5]-0.01];
hfig.PaperPositionMode = 'manual';
print(hfig,'-dpdf',fullfnmsv,'-painters');
close(hfig);
end