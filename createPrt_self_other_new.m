function createPrt_self_other_new(fileLocation,seq,outputDir)
load(fileLocation)
TimeEndExp = 756000;
% write_prt(subject,run,cons,varibls,colors)
[~, partName] = fileparts(fileLocation);
prtFileNameToWrite = fullfile(outputDir,[ partName '.prt']);
% check if its a prt that should be shortened 
if strcmp(partName,'ObservationRun1_Subject_2000')
    shorten = 1 ;
else
    shorten = 0;
end
% will use 'add rest' BVQX function to add rest to prt 
cons{1}=['self'];
cons{2}=['other'];
cons{3}=['catch_trial'];

colors(1,:)=[0,    0,    255];%[randi(255,1) randi(255,1) randi(255,1)];
colors(2,:)=[0,   128,   64];%[randi(255,1) randi(255,1) randi(255,1)];
colors(3,:)=[255,   128,   0];%[randi(255,1) randi(255,1) randi(255,1)];
 
% self / other
% 1,2,3 = self word 1=600 = dog, word 2 = 601 = hen , word 3 = 602 = ram
% 4,5,6 = other word 1 word , word 3
% 7 = catch trial

% new sequence based on above 
newSeq = [];
newSeq(find(seq<4)) = 1; % self 
newSeq(find(seq>3 & seq < 7)) = 2; % other 
newSeq(find(seq==7)) = 3; % catch trial 

if shorten
    newSeq = newSeq(1:end-4);
    TimeEndExp = 735000;
end


prt = xff('prt');

time=15000;
for  i = 1:length(cons)
    onsets = [];
    conName = [];
    colorsToUse = [];
    conName = cons{i};
    onsets(:,1) = find(newSeq==i)*time ;
    onsets(:,2) = find(newSeq==i)*time + 6000;
    colorsToUse = colors(i,:);
    prt = prt.AddCond(conName, onsets ,colorsToUse);
end

opts.maxtime = TimeEndExp;
opts.color = [ 50 50 50 ];
prt = prt.AddRest(opts);

prt.SaveAs(prtFileNameToWrite);

end