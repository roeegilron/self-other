function createVMP(ansMat,mask,locations, pn, fn, params)
% get vmp original data
vmp = getVMPoriginal(pn,mask); % important to start from this map
% get vmp of T stat
vmp = getVMPtstat(ansMat,pn,fn,locations,mask,vmp);
% get vmp P stat
pCutOff = [0.05, 0.001 , 0.005, 0.01, 0.1];
for i = 1:length(pCutOff)
    vmp = getVMPpstat(ansMat,pn,fn,locations,mask,pCutOff(i),vmp);
end

% get vmp at T cut off (cluster based stats) 
tCutOff = calcTCutOffRanges(ansMat, fn);
for i = 1:length(tCutOff)
    vmp = getVMPpstatAtThresh(ansMat,pn,fn,locations,mask,tCutOff(i),vmp, params);
end
%join all the vmps into one vmp map and save it
vmp.SaveAs(fullfile(pn,[fn '.vmp']));
end