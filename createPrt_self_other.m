function createPrt_self_other(subject,run,seq)
rootDir='C:\Users\Roee Gilron\Dropbox\3_letter_experiment\3_letter_exp_final_version';
load(fullfile(rootDir, ['ObservationRun' num2str(run) '_Subject_' num2str(subject) ]))
catchTrials(find(catchTrials==1)+1)=1;
TrialsPerExp=48;
cons{1}=['blank'];
cons{2}=['self'];
cons{3}=['other'];
cons{4}=['catch_trial'];

% self / other
% 1,2,3 = self word 1=600 = dog, word 2 = 601 = hen , word 3 = 602 = ram
% 4,5,6 = other word 1 word , word 3
% 7 = catch trial

% create blank con:
time=15000;
for i=1:TrialsPerExp
    varibles{1}(i,1)=time*i+6000;
    varibles{1}(i,2)=time*i+6000+9000;
end
% add first blank last blank:
varibles{1}=[0 , 15000 ; varibles{1} ; 735000+6000 ,  735000+21000 ];

% create the rest of the cons:
for i=1:TrialsPerExp
    if catchTrials(i)==1 % catch trials
        varibles{4}(i,1)=time*i;
        varibles{4}(i,2)=time*i+6000;
    elseif seq(i)==1 || seq(i)==2 || seq(i)==3 % self 
        varibles{2}(i,1)=time*i;
        varibles{2}(i,2)=time*i+6000;
    elseif seq(i)==4 || seq(i)==5 || seq(i)==6 % other
        varibles{3}(i,1)=time*i;
        varibles{3}(i,2)=time*i+6000;
    end
end

%get rid of zeros from catch trials
varibles{2}=varibles{2}((find(varibles{2}(:,1)~=0)),:);
varibles{3}=varibles{3}((find(varibles{3}(:,1)~=0)),:);
varibles{4}=varibles{4}((find(varibles{4}(:,1)~=0)),:);

%create the colors
colors(1,:)=[0 0 0 ];
colors(2,:)=[109,    69,    51];%[randi(255,1) randi(255,1) randi(255,1)];
colors(3,:)=[210,   110,   227];%[randi(255,1) randi(255,1) randi(255,1)];
colors(4,:)=[100,   197,   102];%[randi(255,1) randi(255,1) randi(255,1)];

% write_prt(subject,run,cons,varibls,colors)
write_prt_msec(subject,['obs_Run_' num2str(run)],cons,varibles,colors);
end