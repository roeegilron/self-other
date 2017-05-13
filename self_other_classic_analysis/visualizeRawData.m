function visualizeRawData()
rootDir = 'F:\vocalDataSet\processedData\matFilesProcessedData\vocalDataSetResults\';
fn = 'RFXdatastats_normalized_sep_beta_.mat';
fnz ='RFXdatastats_normalized_sep_beta_zscored.mat';
load(fullfile(rootDir,fnz));

deltaData = data(labels==1,:)-data(labels==2,:);
figure; hold on;
subplot(1,2,1); 
hold on;
probSubs = [50 138 143];% very large values 
incldsvs = setdiff(1:218,probSubs);
deltaData = deltaData(incldsvs,:);
for i = 1:size(deltaData)
    if max(deltaData(i,:)) > 15
        fprintf('%d ',i);
    end
    histogram(deltaData(i,:),'BinWidth',0.1,'DisplayStyle','stairs');
end
xlabel('Beta Value'); 
ylabel('count'); 
title('histogram of all subjects raw beta values'); 
subplot(1,2,2);
hold on;
plot(1:size(deltaData,2),sort(mean(deltaData,1)),'LineWidth',2)
plot(1:size(deltaData,2),sort(median(deltaData,1)),'LineWidth',2)
xlabel('idx sorted voxels'); 
ylabel('mean / median beta values across subjects')
title('sorted beta values mean / median'); 
legend({'mean','median'}); 

end