function seq=generateSequencesForGLM_PRT_localizer_newVer(fileToLoad)
% load the file
load(fileToLoad);
% only counting times subject drew 
numOfTrials = length([all_data.trial]);
% generate the seqence 
seq=zeros(1,numOfTrials);
seq(1:end) = 1; % same condition 
end
