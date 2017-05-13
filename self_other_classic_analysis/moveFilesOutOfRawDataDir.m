function moveFilesOutOfRawDataDir()
rootDir = '/home/hezi/roee/vocalDataSet/extractedDataVocalDataSet';
subDirs = findFilesBVQX(rootDir,'sub*',struct('dirs',1,'depth',1));
searchPattern = {'sub','asub','wasub','swasub'};
dirNamesToCreate = {'rawData','realigned_data','normalized_data','smoothed_data'};
s150 = subsUsedGet(150);
s20 = subsUsedGet(20);
substorun = sort(setdiff(s150,s20));
rootdir =  '/home/hezi/roee/vocalDataSet/extractedDataVocalDataSet/';

for i = 1:length(substorun);% loop on each subject 
	subfold = sprintf('sub%.3d_Ed',substorun(i));
	subFuncDir = fullfile(rootdir,subfold,'func');
        moveToDir = fullfile(subFuncDir);
        filesToMove= fullfile(subFuncDir,dirNamesToCreate{1},...
            [searchPattern{j} '*.nii']);
	[fn,pn] = fileparts(subFuncDir);
	try
	    movefile(filesToMove,[moveToDir]);   
	catch
			fprintf('did not move files for sub %s dir %s\n',fn,dirNamesToCreate{j})
	end

	[fn,pn] = fileparts(subFuncDir);
	[pn,fn] = fileparts(fn);
	fprintf('moved files for sub %s\n',fn)
end
end
