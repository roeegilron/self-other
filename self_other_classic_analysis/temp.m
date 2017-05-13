rawFind = importdata('D:\Roee_Main_Folder\1_AnalysisFiles\Poldrack_RFX\vocalDataSet\logF.txt');
for i = 1:218
    subStr = sprintf('%3.3d',i);
    strfind(rawFind,subStr)
end