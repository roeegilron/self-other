function trimResultsSlsize9()
datdir = 'F:\vocalDataSet\processedData\matFilesProcessedData\vocalDataSetResults\ffxNotZscored_VocalData_Set1000_Shufs_9slsize_not_smoothed';

ff = findFilesBVQX(datdir,'*.mat');

for i = 1:length(ff)
    mfo = matfile(ff{i}); 
    [pn,fn] = fileparts(ff{i});
    details = whos(mfo);
    dimsansmat = details(1).size;
    if dimsansmat(2) < 100 % remove files with small counts of shuffels 
        delete(ff{i})
    end
    fprintf('%s = \t %d %d %d shufs\n',fn(27:30),dimsansmat);
    subnums(i) = str2num(fn(28:30));
end
setdiff(1:218,subnums)
end