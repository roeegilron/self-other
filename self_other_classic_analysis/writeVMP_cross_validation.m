function writeVMP_cross_validation()
[settings,params] = get_settings_params_self_other();
ffxResFold = settings.resdir_ss_prev_cv;
srcpat  = 'Nondirection*.mat';
ff  = findFilesBVQX(ffxResFold,srcpat);
fprintf('found %d files:\n',length(ff)); 
for f = 1:length(ff)
    [pn,fn]= fileparts(ff{f});
    fprintf('[%d] %s\n',f,fn)
end
idxload = input('choose file to load ');
load(ff{idxload});
cutOff = 0.05;
SigFDR = fdr_bh(pval,cutOff,'pdep','yes');
% Pval(Pval>cutOff) = 0;
SigFDR = double(SigFDR);
%% sig map 
vmpdat = scoringToMatrix(map,SigFDR,locations); % note that SigFDR must be row vector
writeVMP_given3dbrain(vmpdat, 'sig2ndlevel',ffxResFold)

%% pval map 
vmpdat = scoringToMatrix(map,pval,locations); % note that SigFDR must be row vector
writeVMP_given3dbrain(vmpdat, 'pval2ndlevel',ffxResFold)

%% ans Mat real map 
vmpdat = scoringToMatrix(map,ansMatReal,locations); % note that SigFDR must be row vector
writeVMP_given3dbrain(vmpdat, 'ansMatReal',ffxResFold)

end