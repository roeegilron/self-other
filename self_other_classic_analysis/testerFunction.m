function testerFunction(num1,num2,num3)
uuid = char(java.util.UUID.randomUUID);
fid = fopen(fullfile(pwd,sprintf('log_%s_.txt',uuid)));
fprintf(fid,'test %d %d %d',num1,num2,num3);
fclose(fid);
end