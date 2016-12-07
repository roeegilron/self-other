function             [dataout, labelsout] = trimdataforprev(data,labels,trialskeep)
idxA = find(labels==1); 
idxB = find(labels==2); 
idxAshuf = idxA(randperm(length(idxA)));
idxBshuf = idxB(randperm(length(idxB)));

dataAout = data(idxAshuf(1:trialskeep),:);
dataBout = data(idxBshuf(1:trialskeep),:);

dataout = [dataAout ; dataBout]; 
labelsout = [ones(size(dataAout,1),1) ; ones(size(dataBout,1),1).*2];
end
