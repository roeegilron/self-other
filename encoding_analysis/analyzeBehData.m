function resStats = analyzeBehData(fNToanalyze,subject)
load(fNToanalyze)
test_data = testData;
subJects=[test_data.subject];
conds=[test_data.cond];
subresps = [test_data.sub_resp];
correctResponse = zeros(length(subJects),1);
correctResponse(find(subJects == subject)) = 1;
correctResponse(find(subJects ~= subject)) = 2;

idxCatch = find(catchTrials==1);

% trim all the data to fit the idxCatch 
subrespsCatch = subresps(idxCatch);
correctResponseCatch = correctResponse(idxCatch)';
condsCatch = conds(idxCatch);

idxAnsr = find(subrespsCatch>0);
resStats.NumAns = length(find(subrespsCatch>0));
resStats.TotalNum = length(subrespsCatch);
resStats.PercCatchAnswrd = resStats.NumAns / resStats.TotalNum;
resStats.Correct = length(find(subrespsCatch(idxAnsr) == correctResponseCatch(idxAnsr)));
resStats.Incorrect = length(find(subrespsCatch(idxAnsr) ~= correctResponseCatch(idxAnsr)));
resStats.PerCorrect = resStats.Correct / resStats.NumAns;

condName = {'aronit','rashamkol','traklin'};
condNums = unique(condsCatch);
for i = 1:length(condName)
    resStats.condResults.(['cond_' condName{i}]).correct = ...
        sum(subrespsCatch(condsCatch==condNums(i)) == correctResponseCatch(condsCatch==condNums(i)));
    resStats.condResults.(['cond_' condName{i}]).incorrect = ...
        sum(subrespsCatch(condsCatch==condNums(i)) ~= correctResponseCatch(condsCatch==condNums(i)));
end
% self / other
% 1,2,3 = self word 1=600 = Aronit, word 2 = 601 = Rashamkol , word 3 = 602
% = Traklin
% 4,5,6 = other word 1 word , word 3
% 7 = catch trial

end