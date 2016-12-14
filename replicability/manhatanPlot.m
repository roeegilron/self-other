function manhatanPlot(pvals,pthresh,percentsubs) 
%% This functions generated a manhaten plot given 
% a vector of pvalues. (voxels x subjects). 
% highlightabove = pval to highlight above 
% pthresh to highlight above 
% percent subs above that threshold 
logpvals  = log10(pvals).*(-1); 
y = reshape(logpvals',size(pvals,1)*size(pvals,2),1); 
x_raw = repmat(1:111,size(pvals,2),1);
x = reshape(x_raw,size(pvals,1)*size(pvals,2),1); 
hfig = figure;
hold on; 
set(hfig,'Position',[1000         849        1188         489]); 
if isempty(pthresh) 
    haxs = scatter(x,y,'filled','MarkerFaceColor','b','MarkerEdgeColor','b',...
    'MarkerFaceAlpha',.2,'MarkerEdgeAlpha',.2);
else
    haxs = scatter(x,y,'filled','MarkerFaceColor','b','MarkerEdgeColor','b',...
        'MarkerFaceAlpha',.2,'MarkerEdgeAlpha',.2);
end

xlim([1-2 size(pvals,1)+2]); 
xlabel('ROI #'); 
ylabel('ind. sub. p-values ( -log_1_0 * pval)'); 
set(findall(hfig,'-property','FontSize'),'FontSize',16,'FontName','TimeNewRoman')
basettl = 'Manhatan Plot of individual subject p-values';
plottitle = sprintf('%s %% %.2f subs with pval < %.3f',...
    basettl,percentsubs,pthresh);
title(plottitle,'FontSize',18,'FontName','TimeNewRoman'); 

% draw 0.01 line 
puse = log10(0.01) * (-1);
line([0, size(pvals,1)],[puse puse],...
    'LineStyle','--',...
    'Color',[0.2 0.2 0.2],...
    'LineWidth',1.5);
t = text(100,puse+0.1,'p = 0.01',...
    'FontName','TimesNewRoman',...
    'FontSize',20);
t(1).FontWeight = 'Bold'; 
t(1).Color = [0.2 0.2 0.2];
% draw 0.05 line 
puse = log10(0.05) * (-1);
line([0, size(pvals,1)],[puse puse],...
    'LineStyle','--',...
    'Color',[0.4 0.4 0.4],...
    'LineWidth',1.5);
t= text(100,puse+0.1,'p = 0.05',...
    'FontName','TimesNewRoman',...
    'FontSize',20);
t(1).FontWeight = 'Bold'; 
t(1).Color = [0.4 0.4 0.4]; 

% draw 0.1 line 
puse = log10(0.1) * (-1);
line([0, size(pvals,1)],[puse puse],...
    'LineStyle','--',...
    'Color',[0.6 0.6 0.6],...
    'LineWidth',1.5);
t = text(100,puse+0.1,'p = 0.1',...
    'FontName','TimesNewRoman',...
    'FontSize',20);
t(1).FontWeight = 'Bold'; 
t(1).Color = [0.6 0.6 0.6]; 

figdir = fullfile('..','..','figures','replicability'); 
if isempty(pthresh)
    figname = sprintf('manplot_raw.jpeg');
    ffignme = fullfile(figdir, figname); 
else
    figname = sprintf('manplot_pthre-%.2f_perc_subs-%.2f-.jpeg',...
        pthresh,percentsubs); 
    ffignme = fullfile(figdir, figname); 
end
hfig.PaperPositionMode = 'auto';
print(hfig,'-djpeg',ffignme,'-opengl','-r300');

end