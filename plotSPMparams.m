function plotSPMparams()
[filename, pathname]=uigetfile('rp*.txt','select spm motion correction file starting with rp');
rpf=importdata(fullfile(pathname,filename));
% do the radiens to degrees transform
rpf(:, 4:6) = (180 / pi) .* rpf(:, 4:6);

nvol=size(rpf(:,2));

 opts.color = ...
        {[0, 0, 0.75], [0, 0.75, 0], [0.75, 0, 0], ...
         [0.2, 0.2, 1], [0.2, 1, 0.2], [1, 0.2, 0.2]};
     
figure;
tx = subplot(2, 1, 1);
hold(tx, 'on');
rx = subplot(2, 1, 2);
hold(rx, 'on');
ax = [tx, rx];
title(tx, 'Translation');
ylabel(tx, 'mm');
title(rx, 'Rotation');
ylabel(rx, 'degrees');
tl = plot(tx, 1:nvol, rpf(:, 1:3));
rl = plot(rx, 1:nvol, rpf(:, 4:6));
set(tl(1), 'Color', opts.color{1});
set(tl(2), 'Color', opts.color{2});
set(tl(3), 'Color', opts.color{3});
set(rl(1), 'Color', opts.color{4});
set(rl(2), 'Color', opts.color{5});
set(rl(3), 'Color', opts.color{6});
    legend(tx, 'trans-X', 'trans-Y', 'trans-Z');
    legend(rx, 'pitch', 'roll', 'yaw');
