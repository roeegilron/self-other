function writeDataFromServerToVMP(ansMat,subName,outputFileName,res)
fN = 'ss1_GuydataForDoSearchLightReal.mat';
fN = 'ss10_Yael_realDataServerAnalysis_zscore_withPSC_motor_arielBenchMarkV3.mat';
load(fN,'locations','map');
ansMat(:,2) = ansMat(:,2)*10;
fmrData = scoringToMatrix(128, ansMat, locations);
outputData(1).data = strechMatrix(locations, locations, fmrData);
outputData(1).mapName = [subName '_searchlight_shuffle'];
outputData(1).lowerThresh = 6.5;
outputData(1).upperThresh = 10;

writeToVmpTAL_multipleMaps(outputFileName, outputData, map,res) 




end

