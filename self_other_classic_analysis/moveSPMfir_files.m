function moveSPMfir_files()
subsUsedGet(20); 
rtdir = '/home/hezi/roee/vocalDataSet/extractedDataVocalDataSet/';

'func'
'stats_normalized_sep_beta_FIR_ar'; 
foldout = fullfile('/home/hezi/roee/vocalDataSet/','spm_fir_files')
mkdir(foldout);
subsused = subsUsedGet(20); 
for j = [ 1 3]
	for i  = 1:length(subsused) 
		subnum = sprintf('%.3d',subsused(i));
		subfold = sprintf('sub%.3d_Ed',subsused(i));
		arfold = sprintf('stats_normalized_sep_beta_FIR_ar%d',j);
		file2move = fullfile(rtdir,subfold,'func',arfold,'SPM.mat');
		movefn = sprintf('SPM_s-%s_FIR_AR%d.mat',subnum,j);
		copyfile(file2move,fullfile(foldout,movefn));		
	end
end

end
