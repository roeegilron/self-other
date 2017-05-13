function calcFAofMeanEPIofBlanks()
rootfoler = uigetdir();
% get sub folders 
subfolders = findFilesBVQX(rootfoler,'sub*',struct('dirs',1,'maxdepth',1));
for i = 1:length(subfolders) % loop on subject
    % find epi normalized files 
    start = tic;
    epifnms = findFilesBVQX(subfolders{i},'w*.nii');
    mean_w_epis_img(:,:,:,i) = averageNII(epifnms);
    fprintf('sub %d took %f secs\n',i,toc(start));
end
% zscore the mean epis: 
mean_w_epis_img_zscored = zeros(size(mean_w_epis_img));
for i = 1:size(mean_w_epis_img)
    tmp  = mean_w_epis_img(:,:,:,i);
    mu=mean(tmp(:)); s=std(tmp(:));
    mean_w_epis_img_zscored(:,:,:,i) = (tmp-mu)./s;
end
save(fullfile(rootfoler,'meanEpiBlanks.mat'),'mean_w_epis_img','mean_w_epis_img_zscored');

%% convert these mean EPI's to a movie: 
colormap('gray');
largeimg = zeros(200, 200);
rawimgs = mean_w_epis_img_zscored;
for i = 1:size(rawimgs,4)
    % get data in right orientation 
    datx = fliplr(imrotate(squeeze((rawimgs(45,:,:,i))),90));
    daty = imrotate(squeeze((rawimgs(:,45,:,i))),90);
    datz = imrotate(squeeze((rawimgs(:,:,45,i))),90);
    % create montage 
    largeimg = zeros(200, 200);
    largeimg(1:79,1:95) = datx; % place x 
    largeimg(1:79,100:179-1) = daty; % place y 
    largeimg(100:195-1,100:179-1) = datz; % place y 
    
    amin = min(largeimg(:)); amax = max(largeimg(:)); 
    img = mat2gray(largeimg,[amin amax]);
    newimg = im2uint8(img);
%     [y, newmap] = cmunique(newimg);
%     yout(:,:,i) = y;
    f(i) = im2frame(newimg,gray(256));
end
%save the movie

v = VideoWriter('testMov.avi','Indexed AVI');
v.Colormap = gray(256);
v.FrameRate = 8;
open(v)
writeVideo(v,f)
close(v)
end