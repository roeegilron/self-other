function MAIN_create_sep_beta_per_sub()
p = genpath('D:\Roee_Main_Folder\1_AnalysisFiles\Poldrack_RFX\');
addpath(p);
clc
clear all
rootDir = 'D:\Roee_Main_Folder\1_AnalysisFiles\MRI_Data_self_otherv3\MRI_data\SubjectsData\subjects_3000_study';
subdirs = findFilesBVQX(rootDir,'3*',struct('dirs',1,'depth',1));
%% load mask, locations
rtdr = 'D:\Roee_Main_Folder\1_AnalysisFiles\MRI_Data_self_otherv3\MRI_data\SubjectsData\subjects_3000_study\dataForServer_self_other_3000\SO_tp3_new_v5';
fnm = 's3000_realDataServerAnalysis_self-other_psc_timepoint3.mat';
mfo = matfile(fullfile(rtdr,fnm));
locations = mfo.locations;
mask = double(mfo.map);
%% results dir
resltsdir = 'D:\Roee_Main_Folder\1_AnalysisFiles\MRI_Data_self_otherv3\MRI_data\SubjectsData\subjects_3000_study\dataForServer_SepBeta';
for i = 1:length(subdirs) % loop on sub dirs
    subdir = fullfile(subdirs{i},'functional');
    [pn,fn] = fileparts(subdir);     [pn,subnumstr] = fileparts(pn);
    rundirs = findFilesBVQX(subdir,'run*',struct('dirs',1,'depth',1));
    data = []; labelsso = []; labelsoo = []; labelswrd = [];
    for j = 1:length(rundirs)
        glmfn = findFilesBVQX(rundirs{j},'*_with_motion.glm');
        glm = BVQXfile(glmfn{1});
        % get labels
        dataflat = flattenData(glm.GLMData.BetaMaps,locations);
        [lblso,lbloo,lblwrd] = getlabels(glm.Predictor);
        data = [data ; dataflat];
        labelsso = [labelsso ; lblso];
        labelsoo = [labelsoo ; lbloo];
        labelswrd = [labelswrd ; lblwrd];
    end
    fnm2sv = sprintf('data_%s.mat',subnumstr);
    save(fullfile(resltsdir,fnm2sv),...
        'data','mask','locations',...
        'labelsso',...
        'labelsoo',...
        'labelswrd');
end
end

function [lblso,lbloo,lblwrd] = getlabels(prdnmns)
tbl = struct2table(prdnmns);
%% get self other labels:
lblso = zeros(length(prdnmns),1);
idxsother = findnonemptyidxs(strfind(tbl.Name2,'other')) ;
idxsself = findnonemptyidxs(strfind(tbl.Name2,'self')) ;
lblso(idxsself) = 1;
lblso(idxsother) = 2;
%% get other other labels
lbloo = zeros(length(prdnmns),1);
% loop on other indices, and classify others
for i = 1:length(idxsother)
    rawname = tbl.Name2(idxsother(i));
    othersub = regexp(rawname,'[0-9]+','match');
    otherss(i) = str2num(othersub{1}{1});
end
unqsubs = unique(otherss);
if length(unqsubs) ==1 % only one other shown
    lbloo = [];
else
    idxother1 = find(otherss==unqsubs(1));
    idxother2 = find(otherss==unqsubs(2));
    lbloo(idxsother(idxother1)) = 1;
    lbloo(idxsother(idxother2)) = 2;
end
%% get word 1 word 2 labels
lblwrd = zeros(length(prdnmns),1);
idxsaronit = findnonemptyidxs(strfind(tbl.Name2,'arnoit')) ;
idxstraklin = findnonemptyidxs(strfind(tbl.Name2,'Traklin')) ;
idxscatch = findnonemptyidxs(strfind(tbl.Name2,'catch')) ;
idxstraklin = setdiff(idxstraklin,idxscatch);% get rid of cathc trials
idxsaronit = setdiff(idxsaronit,idxscatch);% get rid of cathc trials
lblwrd(idxstraklin) = 1;
lblwrd(idxsaronit) = 2;

end

function idxs = findnonemptyidxs(rawidxs)
idxs = [];
for i = 1:length(rawidxs)
    if ~isempty(rawidxs{i})
        idxs = [idxs, i];
    end
end
idxs = idxs';
end