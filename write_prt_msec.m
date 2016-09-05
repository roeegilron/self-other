function write_prt_msec(subject,run,cons,varibls,colors) % writte PRT
%%write_prt(subject,run,cons,varibls,colors)
%Input Paramaters: 
% subject = int of subject number for output PRT filename
% run = string of run number for ouput PRT filename
% cons = cell array of strings with the names of regressors, should match (in terms of length):
% varibls = cell array of martices that has the start and end time of each
 %                  event in msec in the format: [starttime1 , end time1 ;  starttime2 , endtime 2]
 % colors = matrix of the colors you want each regressor to have in RGB

fid=fopen( [num2str(subject) '_prt_'  run   '.prt'],'wt');
fprintf(fid,'\n%s\n','FileVersion: 2')
fprintf(fid,'\n%s\n','ResolutionOfTime: msec')
fprintf(fid,'\n%s\n','Experiment: 3 LETTER 2000 subjects')
fprintf(fid,'\n%s\n','BackgroundColor: 0 0 0')
fprintf(fid,'\n%s\n','TextColor: 255 255 255')
fprintf(fid,'\n%s\n','TimeCourseColor: 255 255 255')
fprintf(fid,'\n%s\n','TimeCourseThick: 3')
fprintf(fid,'\n%s\n','ReferenceFuncColor: 0 0 80')
fprintf(fid,'\n%s\n','ReferenceFuncThick: 3')
fprintf(fid,'\n%s\n',['NrOfConditions: ' num2str(length(cons)) ]) % number of con / pred/ reg/ in PRT 

for i=1:length(cons)
    fprintf(fid,'\n%s\n', cons{i})
    fprintf(fid,' %i  \n ', size(varibls{i},1)   )
    fprintf(fid,' %i \t %i \t  \n ',varibls{i}') %transposing is important bcs of order that fprintf displays values in
    fprintf(fid,'%s %i \t %i \t %i  \n ','Color:	',colors(i,:))
end
fclose('all');
end