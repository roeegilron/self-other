% load shuffDeltaFFX.mat;
% load shuffDeltaRFX.mat;
load preComputed_Directional_FFX_Data_20-subs_1000-shufs_cvFold20.mat
load precomputed_fixedshufflabels_Directional_RFX_Data_20-subs_1000-shufs_cvFold20.mat
meanShuffDeltaFFX = squeeze(mean(ffxData(:,:,2:end),1))';
meanShuffDeltaRFX = squeeze(mean(rfxData(:,:,2:end),1))';



varShuffDeltaFFX = squeeze(var(ffxData(:,:,2:end),1))';
varShuffDeltaRFX = squeeze(var(rfxData(:,:,2:end),1))';

%% var across subjects - per voxels 
varFFX = var(meanShuffDeltaFFX);
varRFX = var(meanShuffDeltaRFX);
shuffIdx = 700;
oneshufffx = squeeze(ffxData(:,:,shuffIdx));
varffx = var(oneshufffx);


oneshufRfx = squeeze(rfxData(:,:,shuffIdx));
varrfx = var(oneshufRfx);

figure;
hold on;
histogram(varFFX,'BinWidth',0.005); 
histogram(varRFX,'BinWidth',0.005); 
legend({'FFX','RFX'});

figure;
hold on
vox1 = 50 ;
vox2 = 8e3;
scatter(meanShuffDeltaFFX(:,vox1),meanShuffDeltaFFX(:,vox2));
scatter(meanShuffDeltaRFX(:,vox1),meanShuffDeltaRFX(:,vox2));
xlabel(sprintf('Vox %d',vox1))
ylabel(sprintf('Vox %d',vox2))
legend({'FFX','RFX'});
title('shuffle histogram in two voxel case rfx/ffx');

%% look at histograms of delta of data 
figure; 
idxToChoose = randperm(32482,4);
splt1 = 2; splt2 = 2;
for i = 1:length(idxToChoose)
subplot(splt1,splt2,i);
hold on; 
histogram(varShuffDeltaFFX(:,idxToChoose(i)),'BinWidth',0.05); 
histogram(varShuffDeltaRFX(:,idxToChoose(i)),'BinWidth',0.05); 
legend({'real','shuf'});
%set(gca,'Ylim',[0 500]); set(gca,'XLim',[-2 2]);
title(sprintf('comparison of RFX / FFX shuffle %d',i));
xlabel('mean of delta value acorss voxels');
ylabel('count');
legend({'FFX','RFX'});
hold off;
end

%% look at a few histograms of rfx vs ffx 
figure; 
idxToChoose = randperm(1000,10);
splt1 = 1; splt2 = 2;
for i = 1:length(idxToChoose)
subplot(splt1,splt2,1);
hold on; 
histogram(meanShuffDeltaFFX(idxToChoose(i),:),'BinWidth',0.03); 
set(gca,'Ylim',[0 5e3]); set(gca,'XLim',[-2 2]);
title('ffx shuffels overlayed');
xlabel('mean of delta value acorss voxels');
ylabel('count');
hold off;
end

for i = 1:length(idxToChoose)
subplot(splt1,splt2,2);
hold on; 
histogram(meanShuffDeltaRFX(idxToChoose(i),:),'BinWidth',0.03); 
set(gca,'Ylim',[0 5e3]); set(gca,'XLim',[-2 2]);
title('rfx shuffels overlayed');
xlabel('mean of delta value acorss voxels');
ylabel('count');
hold off;
end

%% look at scatter pf data 
figure; 
idxToChoose = randperm(1000,4);
splt1 = 2; splt2 = 2;
for i = 1:length(idxToChoose)
subplot(splt1,splt2,i);
hold on; 
scatter(meanShuffDeltaFFX(idxToChoose(i),:),meanShuffDeltaRFX(idxToChoose(i),:));
set(gca,'Ylim',[-2 2]); set(gca,'XLim',[-2 2]);
title(sprintf('scatter of RFX/FFX shuffle %d',i));
xlabel('FFX mean delta (shuff)');
ylabel('RFX mean delta (shuff)');
plot([-2 2],[-2 2],'k','LineWidth',3)
hold off;
end

%% look at scatter of top 10%
figure; 
idxToChoose = randperm(1000,4);
splt1 = 2; splt2 = 2;
for i = 1:length(idxToChoose)
subplot(splt1,splt2,i);
hold on; 
[sortFFX idxFFX ] = sort(meanShuffDeltaFFX(idxToChoose(i),:));
[sortRFX idxRFX ] = sort(meanShuffDeltaRFX(idxToChoose(i),:));
percentVal = 0.75; 
idxToUse = ceil(length(sortFFX)*percentVal);
sortToPloFFX = sortFFX(idxRFX(idxToUse:end));
sortToPloRFX = sortRFX(idxToUse:end);
scatter(sortToPloFFX,sortToPloRFX);
set(gca,'Ylim',[-2 2]); set(gca,'XLim',[-2 2]);
title(sprintf('scatter of top 25%% RFX/FFX shuffle %d',i));
xlabel('FFX mean delta (shuff)');
ylabel('RFX mean delta (shuff)');
plot([-2 2],[-2 2],'k','LineWidth',3)
hold off;
end

