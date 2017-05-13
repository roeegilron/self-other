function [outData,outLabels,fnTosave,subsToExtrct]  = ...
    extractSubjectsFromDataRandmlyMODIFIED(data,labels,numSubsToExtracs,slSize,cvFold)
allSubjects = []; 
for i = 1:218
    allSubjects = [allSubjects, i , i ]; 
end
allSubjects = allSubjects';
rng(cvFold);


% fold 30 - 30K
subsToExtrct =  [    69   127   194   164    55   188   136     7   126    23    90   106   185    12    58   186    76   132    66 ...
    16    40    81   156   134    20    92   207   203   215   163   129   146   121   176    49    13    63    50 ...
   182    34    85    65   168   125    80   148    36   209    74    45   118   216   218   142   173   107    96 ...
   147    33    32   169   157   151    42    89   100    70   196    17   205   201   174    57   197   120];

% fold 31 - 30K
subsToExtrct =  [   114    59    84   178    26   170     1    30   171    97   139    48    51   104    52   110   204   124   165 ... 
   64    72    91   159    47    22    53    77    98   112     4   177     8    18   200    28   183    10    29 ...
   88    56    14    94   149   212   115   189   141   161    35   213     9   116   154   190   152    37   155 ... 
  133   193   158    86   208    79   137   206    62   192    95   199   145   102   119   175     3    19];


% fold 20 - 30K
if cvFold == 20;
subsToExtrct =  [69   127   194    90   106   185    12    58    76   132    66    16    40   146   121   176    49    13   173  120];
end
%fold 21 - 30K 
if cvFold == 21
subsToExtrct =  [   109   171    79   217   218     9    39   157   104    34   216   133    42   155    52   186    57   156    37  59];
end

idxToExtract = [] ; 
for j = 1:length(subsToExtrct)
idxToExtract = [idxToExtract; ...
    find(allSubjects==subsToExtrct(j))];
end
outData = data(idxToExtract,:);
outLabels = labels(idxToExtract); 
fnTosave = sprintf('VocalDataSet_results_%d-subs_%d-slSize_cvFold%d',...
    numSubsToExtracs,slSize,cvFold);
end