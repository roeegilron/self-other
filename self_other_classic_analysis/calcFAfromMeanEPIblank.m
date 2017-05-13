function calcFAfromMeanEPIblank()
% load mean epi blank from all subject
load('F:\vocalDataSet\processedData\matFilesProcessedData\vocalDataSetResults\ffxNotZscoredVocalDataSet_1000_shufs\meanEpiBlanks.mat');
subsUse{:,1} = [    69   127   194   164    55   188   136     7   126    23    90   106   185    12    58   186    76   132    66 ...
    16    40    81   156   134    20    92   207   203   215   163   129   146   121   176    49    13    63    50 ...
    182    34    85    65   168   125    80   148    36   209    74    45   118   216   218   142   173   107    96 ...
    147    33    32   169   157   151    42    89   100    70   196    17   205   201   174    57   197   120 ...
    114    59    84   178    26   170     1    30   171    97   139    48    51   104    52   110   204   124   165 ...
    64    72    91   159    47    22    53    77    98   112     4   177     8    18   200    28   183    10    29 ...
    88    56    14    94   149   212   115   189   141   161    35   213     9   116   154   190   152    37   155 ...
    133   193   158    86   208    79   137   206    62   192    95   199   145   102   119   175     3    19];
% 150 subjects (both 75 folds)
subsUse{:,2} = [   109   171    79   217   218     9    39   157   104    34   216   133    42   155    52   186    57   156    37  59];

%% transform mean EPI value that is 2x2x2 to 3x3x3 using BVQX routine
dummynii = load_nii('F:\vocalDataSet\processedData\processedData\sub001_Ed\wasub001_Ed_00280.nii');
% load locations:
rootDirOriginalData = ...
    'F:\vocalDataSet\processedData\matFilesProcessedData\stats_normalized_sep_beta';
load(fullfile(rootDirOriginalData,'allSubsBetas.mat'),'locations','mask');
params.regionSize = 27;
% get idx to searhch
idx = knnsearch(locations, locations, 'K', params.regionSize);
n = neuroelf;
%% create data in 3x3x3 space:
skipcreate = 1;
if ~skipcreate
    for i = 1:size(mean_w_epis_img,4)
        start = tic;
        dummynii.fileprefix = fullfile(pwd,'temp');
        dummynii.img = mean_w_epis_img(:,:,:,i);
        save_nii(dummynii,fullfile(pwd,'temp.nii'));
        vmptemp = n.importvmpfromspms(fullfile(pwd,'temp.nii'),'a',[],3);
        meanEpiIn3x3(:,:,:,i) = vmptemp.Map.VMPData;
        vmptemp.ClearObject;
        clear vmptemp;
        fprintf('finished sub % d in %f',i,toc(start));
    end
    fnm2sv = 'F:\vocalDataSet\processedData\matFilesProcessedData\vocalDataSetResults\ffxNotZscoredVocalDataSet_1000_shufs\meanEPiblank3x3.mat';
    save(fnm2sv,'meanEpiIn3x3');
end
%load 3x3 mean blank epi 
fnm2sv = 'F:\vocalDataSet\processedData\matFilesProcessedData\vocalDataSetResults\ffxNotZscoredVocalDataSet_1000_shufs\meanEPiblank3x3.mat';
load(fnm2sv);
for i = 1:218
ansMatBlankEPI(:,i) = reverseScoringToMatrix1rowAnsMat(squeeze(meanEpiIn3x3(:,:,:,i)), locations);
end

for s = 1:2 % loop on subject groups 
    for vx = 1:size(ansMatBlankEPI,1)
        dataAtSphere = ansMatBlankEPI(idx(vx,:),subsUse{:,s});
        faEPIblank(vx,s) = calcClumpingIndexSVD(dataAtSphere);
    end
end
% get original FA 
for s = 1:2 
filesFA = {'rawFAmaps_150_subs','rawFAmaps_20_subs_fold21'};
rootDir = 'F:\vocalDataSet\processedData\matFilesProcessedData\vocalDataSetResults\DirectionalVsNondirectionalFFX';
vmpbasefn = filesFA{s}; % just GM has 1
vmp = BVQXfile(fullfile(rootDir,[vmpbasefn  '.vmp']));
faReal3D(:,s)  = reverseScoringToMatrix1rowAnsMat(vmp.Map(4).VMPData, locations); % 4th map is 27 sl
end

%% plot fa real vs fa EPI 

%% plot a scatter plot scaled
hfig = figure();hfig.Position = [404         500        1500         700];
subplot(1,2,1);
hold on;
scalevec = @(x) (x - (min(x)) )/  ( max(x) - min(x));
vecfareal = scalevec(faReal3D(:,1));
vecfaEPIb = scalevec(faEPIblank(:,1));
%scatter(vecfareal,vecfaEPIb,1,'.')
% print only some of the points to make it easier on memory for pdf
idx = floor(linspace(1,length(vecfareal),2e3));
figure;
hold on;
scatter(vecfareal(idx),vecfaEPIb(idx),3,'.')
title('FA values vs FA from EPI 150 subs'); 
xlabel('FA real');
xlim([0 1]);
ylim([0 1]);
ylabel('FA from EPI blank');
% add trend line:
[r pval] = corr(vecfareal,vecfaEPIb,'type','Pearson');
% get rid of highest lowest 5 % in each 
Sfareal = sort(vecfareal); Sfacont = sort(vecfaEPIb);
cutoffidx = floor(length(Sfareal)*0.05); 
trimtoreal(1) = Sfareal(cutoffidx);
trimtoreal(2) = Sfareal(end-cutoffidx);
idxsreal = find(vecfareal < trimtoreal(2) & vecfareal > trimtoreal(1) );
trimtocont(1) = Sfacont(cutoffidx);
trimtocont(2) = Sfacont(end-cutoffidx);
idxscont = find(vecfaEPIb < trimtocont(2) & vecfaEPIb > trimtocont(1) );
idxsuses = intersect(idxscont,idxsreal);
[r pval] = corr(vecfareal(idxsuses),vecfaEPIb(idxsuses),'type','Pearson');

% trend line 
p = polyfit(vecfareal,vecfaEPIb,1);
lin1 = polyval(p,vecfareal);
plot(vecfareal,lin1,'r','LineWidth',2)
x1 = 0.1;
y1 = 0.6;
str1 = sprintf('R spearman = %1.3f',r);
text(x1,y1,str1,'color','r','FontWeight','bold')
axis square

subplot(1,2,2);
hold on;
vecfareal = scaleVector(faReal3D(:,2),'0-1 scaling');
vecfaEPIb = scaleVector(faEPIblank(:,2),'0-1 scaling');
%scatter(vecfareal,vecfaEPIb,1,'.')
% print only some of the points to make it easier on memory for pdf
idx = floor(linspace(1,length(vecfareal),2e3));
scatter(vecfareal(idx),vecfaEPIb(idx),1,'.')
title('FA values vs FA from EPI 020 subs'); 
xlim([0 1]);
ylim([0 1]);
xlabel('FA real');
ylabel('FA from EPI blank');
axis square
% add trend line:
r = corr(vecfareal,vecfaEPIb);
p = polyfit(vecfareal,vecfaEPIb,1);
lin1 = polyval(p,vecfareal);
plot(vecfareal,lin1,'r','LineWidth',2)
x1 = 0.1;
y1 = 0.6;
str1 = sprintf('R{^2} = %1.3f',r);
text(x1,y1,str1,'color','r','FontWeight','bold')
axis square

% print figure
set(findall(hfig,'-property','Font'),'Font','Arial')
set(findall(hfig,'-property','FontSize'),'FontSize',12)
hfig.PaperPositionMode = 'manual';
hfig.PaperOrientation = 'landscape';
% hfig.PaperUnits = 'inches';
% hfig.PaperPosition = [0 0 11.5/2 8/2];
figname = 'FAvalsVsControlFAvals_scaled';
print(figname,'-dpdf','-r150','-painters')
close(hfig);


    %% plot a scatter plot not scaled 
hfig = figure();hfig.Position = [404         500        1500         700];
subplot(1,2,1);
hold on;
vecfareal = faReal3D(:,1);
vecfaEPIb = faEPIblank(:,1);
scatter(vecfareal,vecfaEPIb,1,'.')
title('FA values vs FA from EPI 150 subs'); 
xlabel('FA real');
ylabel('FA from EPI blank');
% add trend line:
r = corr(vecfareal,vecfaEPIb);
p = polyfit(vecfareal,vecfaEPIb,1);
lin1 = polyval(p,vecfareal);
plot(vecfareal,lin1,'r','LineWidth',2)
xlims = xlim; ylims = ylim;
x1 = xlims(1) + 0.1*(xlims(2)-xlims(1));
y1 = ylims(1) + 0.6*(ylims(2)-ylims(1));
str1 = sprintf('R{^2} = %1.3f',r);
text(x1,y1,str1,'color','r','FontWeight','bold')
axis tight 
axis square

subplot(1,2,2);
hold on;
vecfareal = faReal3D(:,2);
vecfaEPIb = faEPIblank(:,2);
scatter(vecfareal,vecfaEPIb,1,'.')
title('FA values vs FA from EPI 020 subs'); 
xlabel('FA real');
ylabel('FA from EPI blank');
axis tight 
axis square
% add trend line:
r = corr(vecfareal,vecfaEPIb);
p = polyfit(vecfareal,vecfaEPIb,1);
lin1 = polyval(p,vecfareal);
plot(vecfareal,lin1,'r','LineWidth',2)
xlims = xlim; ylims = ylim;
x1 = xlims(1) + 0.1*(xlims(2)-xlims(1));
y1 = ylims(1) + 0.6*(ylims(2)-ylims(1));
str1 = sprintf('R{^2} = %1.3f',r);
text(x1,y1,str1,'color','r','FontWeight','bold')
axis square

% print figure 
set(findall(hfig,'-property','Font'),'Font','Arial')
set(findall(hfig,'-property','FontSize'),'FontSize',12)
hfig.PaperPositionMode = 'manual';
hfig.PaperOrientation = 'landscape';
hfig.PaperUnits = 'inches';
hfig.PaperPosition = [0 0 11.5/2 8/2];
figname = 'FAvalsVsControlFAvals_true_values';
print(figname,'-dpdf','-r150','-painters')
close(hfig);
    

%% save data in 3d

save('FArealvsFAepimeanblan.mat','faReal3D','faEPIblank','locations','mask')

faReal3D150 = scoringToMatrix(mask,faReal3D(:,1),locations);
faReal3D020 = scoringToMatrix(mask,faReal3D(:,2),locations);

faEPI3D150 = scoringToMatrix(mask,faEPIblank(:,1),locations);
faEPI3D020 = scoringToMatrix(mask,faEPIblank(:,2),locations);

save('FAepiVsRealin3d.mat','faReal3D020','faReal3D150','faEPI3D020','faEPI3D150');

end