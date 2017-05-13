rootDir = 'F:\vocalDataSet\processedData\matFilesProcessedData\vocalDataSetResults\DirectionalVsNondirectionalFFX';
% rootDir = 'F:\vocalDataSet\processedData\matFilesProcessedData\vocalDataSetResults\DirectionalVsNondirecFFXoneBigShuff\';
ff = findFilesBVQX(rootDir,'*FFX*.mat');
load(ff{3})

%% What Is Driving Effect In Non Directional FFX? 

% The following graphs are an attempt to primarily answer this question: 
% 
%   Why is directional (D) FFX not a subset of nondirectional (ND) ffx? 
%
% The hypothesis was, that if we used the norm as our test statistic, D-FFX
% will finally be a subset of ND-FFX. This is not the case. Regardless of
% which permutation scheme I use (one big happy matrix / regular stelzer
% style permutations) - using the norm as the test statistic fails to show
% any significant voxels passing. Moreover, I can always find cases in
% which D-FFX passes some unique voxels that ND-FFX does not recover.
% 
% In the graphs below, I use a number of differemt test statistics to
% illustrate the problem. These test statistics are:
%
%   1) m&m
%   2) m&m numerator
%   3) m&m denomenator
%   4) dempster
%   5) hoteling
%   6) log of cov delta
%   7) norm

% In each case I show the real delta, computed stelzer style (so this is an
% averegae number across subjects) and the 95% value in the shuffle maps
% (again, each value was computed stelzer style - so each number represents
% an average acorss subjects). 

titelsToPlot = ...
    {'m&m',...
    'm&m numerator',...
    'm&m denomentaor',...
    'dempster',...
    'hotteling',...
    'log of cov delta',...
    'norm'};

for i = 1:7
    figure;
    set(gcf,'Position',[117   403   921   573]);
    cnt = 1;
    %ansMat(voxels,shuffels,calcs)
    subplot(2,2,cnt); cnt = cnt + 1;
    calcIdx = i; %m & m
    realdata = ansMat(:,1,calcIdx);
    [sortedshuffs, idxs] = sort(ansMat(:,2:end,calcIdx),2);
    shufsat95 = sortedshuffs(:,950);
    scatter(realdata,shufsat95)
    % make axis equal 
    xlimits = get(gca,'XLim');
    ylimits = get(gca,'YLim');
    minval = min([xlimits ylimits]);
    maxval = max([xlimits ylimits]);
    set(gca,'XLim',[minval maxval],'YLim',[minval maxval])
    title(titelsToPlot{i});
    xlabel('real data')
    ylabel('95 percent vlaues');
    
    subplot(2,2,cnt); cnt = cnt + 1;
    hold on;
    [sortedrealdata, idxs] = sort(realdata);
    shufsat95sortedbyreal = shufsat95(idxs);
    plot(1:length(shufsat95),shufsat95sortedbyreal);
    plot(1:length(shufsat95),sortedrealdata,'LineWidth',3);
    legend({'95% shuffle data','real data'});
    title(titelsToPlot{i});
    xlabel('count of idx')
    ylabel(titelsToPlot{i});
    hold off;
    
    subplot(2,2,cnt); cnt = cnt + 1;
    pval = calcPvalVoxelWise(ansMat(:,:,calcIdx));
    histogram(pval);
    title(sprintf('histogram - pvalues of %s',titelsToPlot{i}));
    ylabel('count')
    xlabel(titelsToPlot{i});
    
    subplot(2,2,cnt); cnt = cnt + 1;
    hold on;
    pval = calcPvalVoxelWise(ansMat(:,:,calcIdx));
    h1 = histogram(realdata,'BinMethod','sturges');
    bw = h1.BinWidth;
    histogram(shufsat95,'BinWidth',bw);
    title(sprintf('histogram - of real vs 95%% shufs of %s',titelsToPlot{i}));
    ylabel('count')
    xlabel(titelsToPlot{i});
    legend({'real data','95% shuffle'});
    hold off;
end