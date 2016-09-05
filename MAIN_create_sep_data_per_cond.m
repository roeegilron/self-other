function MAIN_create_sep_data_per_cond()
p = genpath('D:\Roee_Main_Folder\1_AnalysisFiles\Poldrack_RFX\matlabCode');
addpath(p);
rtdir = 'D:\Roee_Main_Folder\1_AnalysisFiles\MRI_Data_self_otherv3\MRI_data\SubjectsData\subjects_3000_study\dataForServer_SepBeta';
matfiles  = findFilesBVQX(rtdir,'data*.mat',struct('depth',1));
sodir = fullfile(rtdir,'self_other'); mkdir(sodir);
wordsdir = fullfile(rtdir,'words'); mkdir(wordsdir);
otherotherdir = fullfile(rtdir,'other_other'); mkdir(otherotherdir);

for i = 1:length(matfiles)
    [pn,fn] = fileparts(matfiles{i});
    load(matfiles{i});
    rawdata = data;
    for i = 1:3
        switch i
            case 1
                idxus = find(labelsso>0);
                labels = labelsso(idxus);
                data = rawdata(idxus,:);
                save(fullfile(sodir,fn),...
                    'data','mask','locations','labels');
            case 2
                idxus = find(labelswrd>0);
                labels = labelswrd(idxus);
                data = rawdata(idxus,:);
                save(fullfile(wordsdir,fn),...
                    'data','mask','locations','labels');
            case 3 % check if labels for other other exists 
                if length(labelsoo) > 10
                    idxus = find(labelsoo>0);
                    labels = labelsoo(idxus);
                    data = rawdata(idxus,:);
                    save(fullfile(otherotherdir,fn),...
                        'data','mask','locations','labels');
                else
                    x=2;
                end
        end
    end
end
end