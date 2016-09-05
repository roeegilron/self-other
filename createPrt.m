function createPrt(subject)
run=1;
rootDir='C:\Users\Roee Gilron\Dropbox\3_letter_experiment\3_letter_exp_final_version';
load(fullfile(rootDir, ['ObservationRun' num2str(run) '_Subject_' num2str(subject) ]))
catchTrials(find(catchTrials==1)+1)=1;
TrialsPerExp=48;
cons{1}=['blank'];
cons{2}=['draw'];
cons{3}=['catch_trial'];

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
    if catchTrials(i)==1
        varibles{3}(i,1)=time*i;
        varibles{3}(i,2)=time*i+6000;
    else
        varibles{2}(i,1)=time*i;
        varibles{2}(i,2)=time*i+6000;
    end
end

varibles{2}=varibles{2}((find(varibles{2}(:,1)~=0)),:);
varibles{3}=varibles{3}((find(varibles{3}(:,1)~=0)),:);

%create the colors
colors(1,:)=[0 0 0 ];
colors(2,:)=[randi(255,1) randi(255,1) randi(255,1)];
colors(3,:)=[randi(255,1) randi(255,1) randi(255,1)];

% write_prt(subject,run,cons,varibls,colors)
write_prt_msec(subject,'loca',cons,varibles,colors);
end