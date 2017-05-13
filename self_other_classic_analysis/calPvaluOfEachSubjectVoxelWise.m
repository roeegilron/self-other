function prevData = calPvaluOfEachSubjectVoxelWise() 
skipcalc = 0; 
% location of data:
dataFolder = 'F:\vocalDataSet\processedData\matFilesProcessedData\vocalDataSetResults\ffxNotZscoredVocalDataSet_1000_shufs\';
dataFolder  = 'F:\vocalDataSet\processedData\matFilesProcessedData\vocalDataSetResults\ffxNotZscored_VocalData_Set1000_Shufs_9slsize_not_smoothed';
if ~skipcalc
subsUse = [    69   127   194   164    55   188   136     7   126    23    90   106   185    12    58   186    76   132    66 ...
            16    40    81   156   134    20    92   207   203   215   163   129   146   121   176    49    13    63    50 ...
            182    34    85    65   168   125    80   148    36   209    74    45   118   216   218   142   173   107    96 ...
            147    33    32   169   157   151    42    89   100    70   196    17   205   201   174    57   197   120 ...
              114    59    84   178    26   170     1    30   171    97   139    48    51   104    52   110   204   124   165 ...
            64    72    91   159    47    22    53    77    98   112     4   177     8    18   200    28   183    10    29 ...
            88    56    14    94   149   212   115   189   141   161    35   213     9   116   154   190   152    37   155 ...
            133   193   158    86   208    79   137   206    62   192    95   199   145   102   119   175     3    19];
% subsUse = [ 1:40 111:144];
for i = 1:length(subsUse)
    %% load ansmat for subject 
    substr = sprintf('%.3d',subsUse(i));
    ff = findFilesBVQX(dataFolder,['stats*' substr  '*FFX_results*.mat']);
    [fp,fn] = fileparts(ff{1});
    fprintf('%s\n',fn);
    mfo = matfile(fullfile(fp,fn));
    datasub = mfo.ansMat;
    datasub = datasub(:,:,1);
    pvals = calcPvalVoxelWise(datasub); 
    SigFDR = fdr_bh(pvals,0.05,'pdep','no');
    prevData(i).pvals = pvals; 
    prevData(i).sbjct = subsUse(i); 
    prevData(i).sigmp = SigFDR; 
    prevData(i).pst05 = sum(SigFDR); 
end
save(fullfile(dataFolder,'prevData_9slsize_unsmoothed.mat'),'prevData');
end

%% plot the pvals oad(fullfile(dataFolder,'prevData.mat'),'prevData');
hfig = figure('visible','off'); pltcnt = 1; figcnt = 1;
set(gcf,'Position',[1000  113        1142        1225]);
for i = 1:length(prevData)
    if mod(i,10) == 0 
        hfig.PaperUnits = 'inches';
        hfig.PaperPosition = [0 0 20 15];
        hfig.PaperPositionMode = 'manual';
        figname = sprintf('fig%d.jpeg',figcnt); figcnt = figcnt +1;
        print(figname,'-djpeg','-r300')
        hfig = figure('visible','off'); pltcnt = 1;
        set(gcf,'Position',[1000         113        1142        1225]);
    end
    subplot(5,2,pltcnt); pltcnt =  pltcnt + 1; 
    h = histogram(prevData(i).pvals);
    h.BinWidth = 0.01;
    ttlstr = sprintf('pvals | sub %.3d | # min pval %d',...
        prevData(i).sbjct,sum(prevData(i).pvals == (1/100)));
    title(ttlstr); 
    xlabel('p value');
    ylabel('count of voxels');
    ylim([1 8e3]);
end
hfig.PaperUnits = 'inches';
hfig.PaperPosition = [0 0 20 15];
hfig.PaperPositionMode = 'manual';
figname = sprintf('fig%d.jpeg',figcnt);
print(figname,'-djpeg','-r300')