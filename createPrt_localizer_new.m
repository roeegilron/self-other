function createPrt_localizer_new(fileLocation,seq,outputDir)
load(fileLocation)
%localizer paramaters
pauseLen=21; % time in seconds that will pause in the start and end of experiment
InstrLenLocal=1.5; % length of instruction trial in seconds
trialLenLocal=4.5; % length of trial in seconds
trials_neededLocal=21; %Total number of trials needed 
blankBetweenDrawTraces=9; % Blank time in seconds (for record / localizer)

TimeEndExp = 351000;
% write_prt(subject,run,cons,varibls,colors)
[~, partName] = fileparts(fileLocation);
prtFileNameToWrite = fullfile(outputDir,[ partName '.prt']);
% check if its a prt that should be shortened 
if strcmp(partName,'LocalizerSubject2000')
    shorten = 1 ;
else
    shorten = 0;
end
% will use 'add rest' BVQX function to add rest to prt 
cons{1}=['draw'];

colors(1,:)=[0,    0,    255];%[randi(255,1) randi(255,1) randi(255,1)];
 

% new sequence based on above 
newSeq = [];
newSeq = seq;

if shorten
    TimeEndExp = 312000;
end


prt = xff('prt');

time=15000;
for  i = 1:length(cons)
    onsets = [];
    conName = [];
    colorsToUse = [];
    conName = cons{i};
    onsets(:,1) = find(newSeq==i)*time + 1500;
    onsets(:,2) = find(newSeq==i)*time + 1500 + 4500;
    colorsToUse = colors(i,:);
    prt = prt.AddCond(conName, onsets ,colorsToUse);
end

opts.maxtime = TimeEndExp;
opts.color = [ 50 50 50 ];
prt = prt.AddRest(opts);

prt.SaveAs(prtFileNameToWrite);

end