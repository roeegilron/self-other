function compareSpecificSpheresT2008T2013()
close all
outDir = 'F:\vocalDataSet\processedData\matFilesProcessedData\vocalDataSetResults\DirectionalVsNondirectionalFFX';
fn = 'ND_FFX_VDS_20-subs_27-slsze_1-fld_50shufs_1000-stlzer_mode-equal-min_newT2013.mat';
subsdir = fullfile(pwd,'results_vocal_dataset_FFX_ND_norm_100shuf_SL27_compre_old_new_t');
mkdir(fullfile(pwd,'beamfun'));
exportdir = fullfile(pwd,'beamfun');

load(fullfile(outDir,fn));
subsused = subsUsedGet(20);
% get best idx from average file
realT2013 = avgAnsMat(:,1);
realT2008 = avgAnsMatOld(:,1);
[mx08, idx08]=max(realT2008);
[sorv, idxssort] = sort(realT2008);
[mx13, idx13]=max(realT2013);
% idx test
idxstest(1) = idx08;
idxstest(2) = floor(length(idxssort)*0.95); % 95 perc
idxstest(3) = floor(length(idxssort)*0.5); % mid pack
idxtestlegnd = {'max_sphere','95p_sphere','50p_sphere'};

for s = 1:length(subsused)
    subcheck = subsused(s);
    % load sub
    ff = findFilesBVQX(subsdir,sprintf('*sub_%.3d*.mat',subcheck));
    load(ff{1});
    realt08 = squeeze(ansMatOld(:,1,1));
    realt13 = ansMat(:,1);
    rval = corrcoef([realt08,realt13],'rows','pairwise');
    
    hfig = figure;
    hfig.Position = [93         392        1467         946];
    hfig.Visible = 'off';
    nr = 4; nc = 3; cntplt = 1;
    subplot(nr,nc,cntplt); cntplt = cntplt+1;
    plotscatter(exportdir,realt08,realt13,rval,subcheck)
    % get one beam and shuffle it
    for m = 1:3
        idxuse = idxstest(m);
        databeam = data(:,idx(idxuse,:));
        
        for i = 1:1e3 + 1
            if i ==1
                labelsuse = labels;
            else
                labelsuse = labels(randperm(length(labels)));
            end
            dataX = databeam(labelsuse==1,:);
            dataY = databeam(labelsuse==2,:);
            tmp = calcTstatAll([],dataX-dataY);
            t08(i) = tmp(1);
            t13(i) = calcTstatMuniMengTwoGroup(dataX,dataY);
        end
        subplot(nr,nc,cntplt); cntplt = cntplt+1;
        plotshufbeam(t08,'T08',subcheck,idxtestlegnd{m})
        subplot(nr,nc,cntplt); cntplt = cntplt+1;
        plotshufbeam(t13,'T13',subcheck,idxtestlegnd{m})
        exportbeam(exportdir,databeam,labels,subcheck,idxtestlegnd{m})
        spherecheck08(s,m) = t08(1);
        spherecheck13(s,m) = t13(1);
    end
    
    subplot(nr,nc,cntplt); cntplt = cntplt+1;
    plotpvalhistogram(ansMat,'T13',subcheck)
    subplot(nr,nc,cntplt); cntplt = cntplt+1;
    ansMatOld = squeeze(ansMatOld(:,:,1));
    plotpvalhistogram(ansMatOld,'T08',subcheck)
    subplot(nr,nc,cntplt); cntplt = cntplt+1;
    plotpvalsorted(ansMatOld,ansMat,subcheck)
    figname = sprintf('s%.3d.jpeg',subcheck);
    figoutname = fullfile(exportdir,figname);
    hfig.PaperPositionMode = 'auto';
    print(figoutname,'-djpeg','-r300')
    close(hfig);
end

idxtestlegnd = {'max_sphere','sphere_95p','sphere_50p'};
ds = mat2dataset(spherecheck08);
ds.Properties.VarNames = idxtestlegnd;
obsname = {};
for i = 1:length(subsused); 
    tmp = mat2str(sprintf('s%.3d\n',subsused(i))); 
    ds.Properties.ObsNames{i} = tmp(3:6);
end
dsname = fullfile(exportdir,'sphereTvalsPerSub08.txt');
export(ds,'File',dsname,'WriteVarNames',true)
mean(spherecheck08,1)

ds = mat2dataset(spherecheck13);
ds.Properties.VarNames = idxtestlegnd;
obsname = {};
for i = 1:length(subsused); 
    tmp = mat2str(sprintf('s%.3d\n',subsused(i))); 
    ds.Properties.ObsNames{i} = tmp(3:6);
end
dsname = fullfile(exportdir,'sphereTvalsPerSub13.txt');
export(ds,'File',dsname,'WriteVarNames',true)
mean(spherecheck08,1)
end

function plotscatter(exportdir,realt08,realt13,rval,sublab)
ttlstr = sprintf('real T08 vs T13 (R = %.2f)',rval(1,2));
scatter(realt08,realt13);
xlabel('Real T08');
xlabel('Real T13');
title(ttlstr);
end

function plotshufbeam(tavls,tlab,sublab,idxlab)
hold on;
histogram(tavls(:,2:end))
pval = calcPvalVoxelWise(tavls);
scatter(tavls(1),2,20,'r')
ttlstr = sprintf('%s (%.3f) s%d %s pval %.3f',...
                tlab,tavls(1), sublab,idxlab,pval);
title(ttlstr); 
xlabel(tlab);
ylabel('count');
end

function exportbeam(exportdir,beam,labels,sublab,idxlab)
fn = sprintf('s%.3d_%s.txt',sublab,idxlab);
data = [labels', beam];
csvwrite(fullfile(exportdir,fn),data);
end

function plotpvalhistogram(ansMat,tlab,sublab)
pval = calcPvalVoxelWise(ansMat);
histogram(pval)
ttlstr = sprintf('%s s%d all pvals ',...
                tlab, sublab);
title(ttlstr); 
xlabel(tlab);
ylabel('count')
end

function plotpvalsorted(ansMatOld,ansMat,sublab)
ttlstr = sprintf('s %d sorted pvals ',...
                 sublab);
pval08 = calcPvalVoxelWise(ansMat);
pval13 = calcPvalVoxelWise(ansMatOld);
hold on;
plot(sort(pval08),1:length(pval08));
plot(sort(pval13),1:length(pval13));
title('sorted pvals T08 T13');
legend({'T08','T13'});

end
