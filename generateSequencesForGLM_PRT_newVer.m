function seq=generateSequencesForGLM_PRT_newVer(fileToLoad)
% mark both catch trials and trials after catch trials as suspect of
% movement. 
load(fileToLoad)
idxRem=find(catchTrials==1);
idxRep=find(catchTrials==1) + 1;
catchTrials(idxRem)=1;
catchTrials(idxRep)=1;

% get the data: 
subJects=[test_data.subject];
conds=[test_data.cond];

% generate the seqence 
seq=zeros(1,length(subJects));

% self / other
% 1,2,3 = self word 1=600 = dog, word 2 = 601 = hen , word 3 = 602 = ram
% 4,5,6 = other word 1 word , word 3
% 7 = catch trial

subject = mode(subJects) ; % self is most freq occuring subject
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
% seq=num2str(seq);
% seq=strrep(seq,' ','');
end
