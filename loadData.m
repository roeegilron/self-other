function data = loadData(fnm)
load(fnm)
dat = data; 
clear data; 
data.data = double(dat); 
data.labels = labels; 
[pn,fn1] = fileparts(fnm);
data.roinm = fn1(19:end); 
[pn,fn] = fileparts(pn);
data.subnm = fn1(10:13); 
end