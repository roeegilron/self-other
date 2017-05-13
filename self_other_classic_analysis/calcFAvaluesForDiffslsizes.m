function calcFAvaluesForDiffslsizes()
rootDir = 'F:\vocalDataSet\processedData\matFilesProcessedData\vocalDataSetResults\DirectionalVsNondirectionalFFX';
uniqfolds = [ 21]%  31]; % XXX AL SUBS 
subsUse = [    69   127   194   164    55   188   136     7   126    23    90   106   185    12    58   186    76   132    66 ...
            16    40    81   156   134    20    92   207   203   215   163   129   146   121   176    49    13    63    50 ...
            182    34    85    65   168   125    80   148    36   209    74    45   118   216   218   142   173   107    96 ...
            147    33    32   169   157   151    42    89   100    70   196    17   205   201   174    57   197   120 ...
              114    59    84   178    26   170     1    30   171    97   139    48    51   104    52   110   204   124   165 ...
            64    72    91   159    47    22    53    77    98   112     4   177     8    18   200    28   183    10    29 ...
            88    56    14    94   149   212   115   189   141   161    35   213     9   116   154   190   152    37   155 ...
            133   193   158    86   208    79   137   206    62   192    95   199   145   102   119   175     3    19];
        % 150 subjects (both 75 folds) 
subsUse = [   109   171    79   217   218     9    39   157   104    34   216   133    42   155    52   186    57   156    37  59];

slsizes = [3 9 27 81 243];
%% calc the FA values
    rootDirOriginalData = ...
        'F:\vocalDataSet\processedData\matFilesProcessedData\stats_normalized_sep_beta';
    load(fullfile(rootDirOriginalData,'allSubsBetas.mat'),'allSubsData','labels','locations','mask');
cnt = 1;
if ~exist(fullfile(rootDir,'favalues.mat'),'file');
    for i = 1:length(uniqfolds)
        for j = 1:length(slsizes)
            start = tic;
            subsused = getSubsUsedInFold(uniqfolds(i));
            subsused = subsUse; % XXXXXX USE ALL SUBS 
            normMaps = calcNormsOfLeftOutSubjects(allSubsData,subsused,locations,labels,slsizes(j));
            famaps(cnt).normMaps = normMaps;
            famaps(cnt).subsused = subsused;
            famaps(cnt).numsubs = length(subsused);
            famaps(cnt).slsize = slsizes(j);
            famaps(cnt).locations = locations;
            famaps(cnt).mask = mask;
            cnt = cnt + 1;
            fprintf('finished map %d with sl size %d and %d num subs in %f secs\n',...
                cnt,slsizes(j),length(subsused),toc(start));
        end
    end
    save(fullfile(rootDir,'famaps_20_SUBS.mat'),'famaps');
else
    load(fullfile(rootDir,'rois.mat'),'rois');
end
