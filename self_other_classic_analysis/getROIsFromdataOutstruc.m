function rois = getROIsFromdataOutstruc(dataOut,subsChoose,unqSigCh,methodUsed)
rois = [];
% rois.mvpa; 
% rois.rfx ;
idxsSub = find(strcmp(dataOut.statMethod,subsChoose)==1);
idxsSig = find(dataOut.cutOffVal == unqSigCh);
idxsMet = find(strcmp(dataOut.methodUsed,methodUsed)==1);
relIdxs = intersect(idxsSub,idxsSig);
relIdxs = intersect(idxsMet,relIdxs);
ffxIdxs = find(strcmp(dataOut.InferenceMet,'FFX')==1);
rfxIdxs = find(strcmp(dataOut.InferenceMet,'RFX')==1);
ffxIdx  = intersect(relIdxs,ffxIdxs);
rfxIdx  = intersect(relIdxs,rfxIdxs);
rois.ffx = dataOut.idxsROI{ffxIdx,1};
rois.rfx = dataOut.idxsROI{rfxIdx,1};
rois.all = unique([rois.ffx(:); rois.rfx(:)]);
rois.minPvalffx = dataOut.NumMinPvalInSigMap(ffxIdx,1);
rois.minPvalrfx = dataOut.NumMinPvalInSigMap(rfxIdx,1);
rois.subsUsedFFX   = dataOut.subsUsed{ffxIdx};
rois.subsUsedRFX   = dataOut.subsUsed{rfxIdx};
end