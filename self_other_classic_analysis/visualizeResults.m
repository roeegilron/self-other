function visualizeResults(ansMat,mask,locations,params)
% mk dir with results
for i = 1:length(params.TestOrder)
    TstatToUse = params.TestOrder{i};
    dirName = ['Tstat_' TstatToUse '_SLsize_' num2str(params.regionSize)];
%     dirName = ['Tstat_' TstatToUse '_SLsize_' num2str(params.regionSize) '_54ss_CV2A'];
    dirPath = fullfile(pwd,'results',dirName);
    mkdir(dirPath);
    % save results
    ansMatToSave = squeeze(ansMat(:,i,:));
%     save(fullfile(dirPath,[dirName '.mat']),...
%         'ansMatToSave','mask','locations','params');
    % create histogram of results
    createHistoram(ansMatToSave, dirPath, dirName)
    % create VMP of results and comparison to ground truth
    createVMP(ansMatToSave,mask,locations, dirPath, dirName, params)
end
% save(fullfile(pwd,['backup_mat_' datestr(clock,30) '.mat']),...
%     'ansMat','mask','locations','params','-v7.3');

end