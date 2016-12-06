function reportSubjectStatistics()
rootdir  = 'F:\RAW_MRI_DATA';
fsubs = findFilesBVQX(rootdir,'RM*',struct('depth',1,'dirs',1));

for i = 1:length(fsubs)
    dcmfls = findFilesBVQX(fsubs{i},'*.dcm');
    dcmhdr = dicominfo(dcmfls{1}); 
    data.sex(i,1) = dcmhdr.PatientSex;
    bdate = datenum(dcmhdr.PatientBirthDate,'yyyymmdd'); 
    adate = datenum(dcmhdr.AcquisitionDate,'yyyymmdd'); 
    page = adate - bdate ;
    data.age(i) = page/365;
    data.scandate{i} = datestr(adate);
    data.fullname{i} = [dcmhdr.PatientName.FamilyName ,' ' , dcmhdr.PatientName.GivenName]; 
    data.prefixname{i} = lower([dcmhdr.PatientName.FamilyName(1:2) ,dcmhdr.PatientName.GivenName(1:2)]); 
end

%% report stats 
fprintf('- - - Summary Stats - - -\n');  
fprintf('\t 1. %d M %d F\n',...
    length(strfind(data.sex','M')),...
    length(strfind(data.sex','F'))); 
fprintf('\t 2. Mean age = %2.1f, Median age = %2.1f [%2.1f - %2.1f] (range)\n',...
        mean(data.age),median(data.age),min(data.age),max(data.age));
fprintf('\t 3. Total of %d subs scanned \n',size(data.sex,1));
fprintf('- - - - - - - - - - - - -\n');
fprintf('\n\n');
fprintf('- - - Details       - - -\n');  
for i = 1:size(data.sex,1)
    fprintf('\t sub %s scanned on %s age %2.2f sex %s\n',...
            data.prefixname{i},...
            data.scandate{i},...
            data.age(i),...
            data.sex(i,1));
end
fprintf('- - - - - - - - - - - - -\n');
end