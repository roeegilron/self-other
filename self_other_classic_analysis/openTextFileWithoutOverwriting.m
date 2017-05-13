function fid = openTextFileWithoutOverwriting(txtFn)
if ~exist(txtFn,'file')
    fid = fopen(txtFn,'w+');
    fprintf(fid,'inference,stat,cutOff,fold,subject,norm\n');
else
    fid = fopen(txtFn,'w+');
end
end