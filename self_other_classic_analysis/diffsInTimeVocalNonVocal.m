function diffsInTimeVocalNonVocal()
rtdir = 'F:\vocalDataSet\processedData\processedData\sub001_Ed';
load(fullfile(rtdir,'onsetsSEP.mat'));
temp = [onsets' ,names'];
timings = cell2table(temp);
vocl = timings(1:20,:);
nvcl = timings(21:40,:);

% report timing problem 
fid = fopen('timingsDifs.txt','w+');
fprintf(fid,'Onset\t\t\tCondition\t\t\tOnset\t\t\tCondition\t\t\tDiff\n');
for i = 1:size(vocl,1)
    fprintf(fid,'%d\t\t\t%s\t\t\t%d\t\t\t%s\t\t\t%d\n',...
        vocl.temp1(i),...
        vocl.temp2{i},...
        nvcl.temp1(i),...
        nvcl.temp2{i},...
        vocl.temp1(i) - nvcl.temp1(i));
end

fprintf(fid,'\n\n'); 
fprintf(fid,'experiment order: \n\n'); 
sortedtimings = sortrows(timings,'temp1');
fprintf(fid,'Onset\t\t\tCondition\t\t\t\n');
for i = 1:size(sortedtimings,1);
    fprintf(fid,'%d\t\t\t%s\t\t\t\n',...
        sortedtimings.temp1(i),...
        sortedtimings.temp2{i});
end
fclose(fid);


% save timings .mat file 
save('timings.mat','timings');
