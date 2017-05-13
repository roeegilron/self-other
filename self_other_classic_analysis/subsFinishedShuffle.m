function subsFinishedShuffle()
rootdir =  '/home/hezi/roee/vocalDataSet/extractedDataVocalDataSet/' ;
statdir =  '/func/stats_normalized_sep_beta_ar3/';
subsused = sort(subsUsedGet(20)); 
s150 = subsUsedGet(150);
s20 = subsUsedGet(20);
subsused = sort(setdiff(s150,s20));
[
cnt = 1;
for i = 1:length(subsused); % loop on subs 
subfold = sprintf('sub%.3d_Ed',subsused(i));
spmname = 'Cbeta.mat';
pathtospm = fullfile(rootdir,subfold,statdir,spmname);
if ~exist(pathtospm,'file');
	missingsubs(cnt) = subsused(i); cnt = cnt + 1;
	fprintf('%.3d missing\n',subsused(i));
end
%subfold = sprintf('sub%.3d_Ed',subsused(i));
%spmname = 'SPM.mat';
%evalc('load(fullfile(rootdir,subfold,statdir,spmname))');
%numreg = length(SPM.xX.name);
%fprintf('%.3d = %d\n',subsused(i),numreg);

end

missingsubs
