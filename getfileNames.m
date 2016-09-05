function fileNameAndPath = getfileNames(rootDir,startsWith,fileType)
[files ] = dir(fullfile(rootDir, [startsWith '*' fileType]));
for i = 1:length(files)
    fileName =  files(i).name;
    fileNameAndPath{i} = fullfile(rootDir,fileName);
end

end

