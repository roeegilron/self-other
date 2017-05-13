function [labelx, labely, pairingname ] = getRealLabelIdxsDiffPairings(idxuse)
load(fullfile(pwd,'timings.mat'));
% create a matrix to easily allow row sorting 
% first column is index, second column is label, third column is time. 
sorttabels = zeros(size(timings,1),3);
sorttabels(:,1) = 1:40;
sorttabels(:,2) = [ones(20,1); ones(20,1)*2];
sorttabels(:,3) = timings.temp1;

switch idxuse
    case 1
        pairingname = 'orig-p';
        labelx = sorttabels(1:20,1);
        labely = sorttabels(21:40,1);
        avgdif = mean(sorttabels(labelx,3) - sorttabels(labely,3));
        stddif = std(sorttabels(labelx,3) - sorttabels(labely,3));
        fprintf('%s mu = %f std = %f\n',pairingname,avgdif,stddif);
    case 2 
        pairingname = 'max-anti-cor';
        labelx = sorttabels(1:20,1);
        labely = sorttabels(40:-1:21,1);
        avgdif = mean(sorttabels(labelx,3) - sorttabels(labely,3));
        stddif = std(sorttabels(labelx,3) - sorttabels(labely,3));
        fprintf('%s mu = %f std = %f\n',pairingname,avgdif,stddif);
    case 3
        pairingname = 'randperm1';
        labelx = sorttabels(1:20,1);
        labely = sorttabels(40:-1:21,1);
        avgdif = mean(sorttabels(labelx,3) - sorttabels(labely,3));
        stddif = std(sorttabels(labelx,3) - sorttabels(labely,3));
        fprintf('%s mu = %f std = %f\n',pairingname,avgdif,stddif);
    case 4
        pairingname = 'randperm2';
        labelx = sorttabels(randperm(20),1);
        labely = sorttabels(randperm(20)+20,1);
        avgdif = mean(sorttabels(labelx,3) - sorttabels(labely,3));
        stddif = std(sorttabels(labelx,3) - sorttabels(labely,3));
        fprintf('%s mu = %f std = %f\n',pairingname,avgdif,stddif);

end

end