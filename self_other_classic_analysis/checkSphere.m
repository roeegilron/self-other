function checkSphere()
basedir = 'D:\Roee_Main_Folder\1_AnalysisFiles\Poldrack_RFX\matlabCode\beamfun\sinlgesubs';
[fn,pn] = uigetfile('*.txt','chooose sphere');
rawdat = importdata(fullfile(pn,fn));
labels = rawdat(:,1);
data = rawdat(:,2:end);
dataX = data(labels==1,:);
dataY = data(labels==2,:);
mtvals = calcTstatMuniMengTwoGroup(dataX,dataY);
end