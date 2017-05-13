function createProbabilityMapRfxFFX()
load PvalsRFX-FFX.mat;
addPathsForServer()
sigLevel = 0.05;
for i = 1:15
    % rfx 
    pVal = eval(sprintf('pValRFX%d',i));
    SigMap = fdr_bh(pVal,sigLevel,'pdep','yes');
    pValMap.RFXpVal(:,i) = pVal;
    pValMap.RFXpSig(:,i) = SigMap;
    fprintf('for map %d num sig %d\n',i,sum(SigMap));
    clear pVal SigMap
    % ffx
    pVal = eval(sprintf('pValFFX%d',i));
    SigMap = fdr_bh(pVal,sigLevel,'pdep','no');
    pValMap.FFXpVal(:,i) = pVal;
    pValMap.FFXpSig(:,i) = SigMap;
end
%% proba map RFX 
probMapRFX = sum(pValMap.RFXpSig,2)./15;
figure;
hold on;
histogram(probMapRFX(find(probMapRFX~=0)));

%% proba map FFX 
probMapFFX = sum(pValMap.FFXpSig,2)./15;
histogram(probMapFFX(find(probMapFFX~=0)));
legend({'RFX','FFX'});
title(sprintf(...
    'RFX / FFX overlap probability (FDR sig %1.2f)',...
    sigLevel))
ylabel('count - voxels'); 
xlabel('Probability of Overlap Across 15 shuffle maps'); 

%% get VMP 
load('RussBaseData.mat','mask','locations');
vmp = getVMPoriginal(pwd,mask); % important to start from this map

%% create probabiliy map 
vmp = getVMPtstat(probMapRFX,pwd,'rfx-probabilityMap-75subs',locations,mask,vmp);
vmp = getVMPtstat(probMapFFX,pwd,'ffx-probabilityMap-75subs',locations,mask,vmp);
vmp.SaveAs()
end