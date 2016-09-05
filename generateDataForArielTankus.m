function generateDataForArielTankus()
subjects= [2000 2001 2002 2003 2005 2006];
pathToSaveIn='C:\DATA\1_AnalysisFiles\FDR_searchLight_Analysis\dataForArielTankus_sub2000s\word1\';
for  i = 1 :length(subjects)
    load(['subTAL' num2str(subjects(i)) '.mat']);
    outData=zeros(size(self,1)+size(other,1),size(self,2) + 1);
    outData(:,1)=[ones(size(self,1),1) ; ones(size(other,1),1)*2]; % lables 
    outData(:,2:end)=[self ; other]; % data 
    save(fullfile(pathToSaveIn,[num2str(subjects(i)) '.mat']), 'outData')
    clear outData self other 
end

end