function writeDataToTextFile(fn)
load(fn);
[pn,fp] = fileparts(fn);
fid = fopen(fullfile(pn,[fp '.txt']),'w+');
fclose(fid);
tic
dlmwrite(fullfile(pn,[fp '.txt']),ansMat);
toc
end