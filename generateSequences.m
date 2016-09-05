function seq=generateSequences(subject,run,AdvanceCatchTrial)
% if advanceCathcTrial is 1 subject did not understand that there is a
% catch trial, otherwise, if 0 just use catch trials as usual. 
rootDir='C:\Users\Roee Gilron\Dropbox\3_letter_experiment\3_letter_exp_final_version';
load(fullfile(rootDir, ['ObservationRun' num2str(run) '_Subject_' num2str(subject) ]))
if AdvanceCatchTrial % subject didn't understand direction, real catch trial is 'one after'
    idxRem=find(catchTrials==1);
    idxRep=find(catchTrials==1) + 1;
    catchTrials(idxRem)=0;
    catchTrials(idxRep)=1;
end
% get the data: 
subJects=[test_data.subject];
conds=[test_data.cond];

% generate the seqence 
seq=zeros(1,length(subJects));

% self / other
% 1,2,3 = self word 1=600 = dog, word 2 = 601 = hen , word 3 = 602 = ram
% 4,5,6 = other word 1 word , word 3
% 7 = catch trial

%self words
seq(intersect(find(subJects==subject),find(conds==600)))=1 ; 
seq(intersect(find(subJects==subject),find(conds==601)))=2 ; 
seq(intersect(find(subJects==subject),find(conds==602)))=3 ; 

%other words
seq(intersect(find(subJects~=subject),find(conds==600)))=4 ; 
seq(intersect(find(subJects~=subject),find(conds==601)))=5 ; 
seq(intersect(find(subJects~=subject),find(conds==602)))=6 ; 

%insert Catch Trials: 
catchTrials(find(catchTrials==1)+1)=1;

seq(find(catchTrials==1))=7;

% convert to string:
seq=num2str(seq);
seq=strrep(seq,' ','');
end
