function zeroporter()
rootdir = 'F:\vocalDataSet\processedData\matFilesProcessedData\stats_normalized_sep_beta\';
subsused150 = subsUsedGet(150);
subsused20 = subsUsedGet(150);
cnt =1;
for i = 1:size(subsused,2) % loop on subs 
    load(fullfile(rootdir,sprintf('data_%.3d',subsused(i))),'data');
    subnans = 0;
    for k = 1:size(data,2); % loop on voxels 
        tmp = data(:,k);
        if  sum(tmp) == 0
            subnans = subnans + 1;
            idxzer(cnt) = k; cnt = cnt + 1;
        end
        
    end
    fprintf('%.3d\n',subsused(i));
    repornan(i,1) = i;
    repornan(i,2) = subnans;
end
end