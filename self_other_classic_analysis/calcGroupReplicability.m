function prevData = calcGroupReplicability()
skipcalc = 1;
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
    
    %% create 10 groups of 15 subjects each
    rng(1);
    subsusedshuff= randperm(length(subsUse));
    subgroup = reshape(subsusedshuff,15,10);
    
    %loop on sub groups:
    for i = 1:size(subgroup,2)
        % pre allocate groupsup matrix
        groupsub = zeros(32482,1001,15);
        %loop on subs in subgroup to create large ansmat
        for k = 1:size(subgroup,1)
            % preallocate datasub
            datasub = zeros(32482,1001,7);
            substr = sprintf('%.3d',subgroup(k,i));
            ff = findFilesBVQX(dataFolder,['stats*' substr  '*FFX_results*.mat']);
            [fp,fn] = fileparts(ff{1});
            fprintf('%s\n',fn);
            mfo = matfile(fullfile(fp,fn));
            datasub = mfo.ansMat;
            groupsub(:,:,k) = datasub(:,:,1);
            clear datasub
        end
        % take median on the group
        medianmap = median(groupsub,3);
        meanmap = mean(groupsub,3);
        pvalsmedian = calcPvalVoxelWise(medianmap);
        pvalsmean = calcPvalVoxelWise(meanmap);
        prevDataGroup.pvalsmedian(:,i) = pvalsmedian;
        prevDataGroup.pvalsmean(:,i) = pvalsmean;
        prevDataGroup.sigFDRmedian(:,i) = fdr_bh(pvalsmedian,0.05,'pdep','no');
        prevDataGroup.sigFDRmean(:,i) = fdr_bh(pvalsmean,0.05,'pdep','no');
        prevDataGroup.SubsUsed(:,i) = subgroup(i,:);
        clear groupsub medianmap meanmap pvalsmedian pvalsmean
    end
    save(fullfile(dataFolder,'prevData_Group9slsize_unsmoothed.mat'),'prevDataGroup','-v7.3');  
else
    load(fullfile(dataFolder,'prevData_Group9slsize_unsmoothed.mat'),'prevDataGroup');
end

end