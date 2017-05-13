params = getParams();
fnTosave = 'test';
slSize = 27;

start = tic;
for i = 1:1001
    timeVec(i) = toc(start);
    reportProgress(fnTosave,i,params, slSize, timeVec)
    pause(0.01);
end