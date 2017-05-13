function createVMPsimple(ansMat,mask,locations )
%% make basic VMP in TAL space, must have BVQX installed 
vmp = BVQXfile('vmp');
dataFromAnsMatBackIn3d = scoringToMatrix(mask,ansMat,locations);

%%%%%%%% optional %%%%%%%%%%%%%%%%%

%% get locations from mask
locations = getLocations(mask);
%% get mask from locations: 
mask = createMaskFromLocations (data,locations); % data is 3d data can be zeros 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% create VMP 

% set some map properties 
vmp.Map = dataFromAnsMatBackIn3d;
% combine the original and t stat vmps , original is blue
vmp.Map.LowerThreshold = 0.6;
vmp.Map.UpperThreshold = 0.7;
vmp.Map.Name = 'originalData';
vmp.Map.RGBLowerThreshPos = [ 0 0 255];
vmp.Map.RGBUpperThreshPos = [ 0 0 255];
vmp.Map.RGBLowerThreshNeg = [ 0 0 255];
vmp.Map.RGBUpperThreshNeg = [ 0 0 255];
vmp.Map.UseRGBColor = 1;


end

