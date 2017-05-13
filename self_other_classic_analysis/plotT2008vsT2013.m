function plotT2008vsT2013(varargin)
if numel(varargin) == 2
    ansMat2008 = varargin{1};
    ansMat2013 = varargin{2};
else
    ansMat2013 = varargin{1};
    pval13 = calcPvalVoxelWise(ansMat2013);
    sigfdrt2013 =fdr_bh(pval13,0.05,'pdep','yes');
    return;
end
pval08 = calcPvalVoxelWise(ansMat2008);
fprintf('T2008:\n')
sigfdrt2008 =fdr_bh(pval08,0.05,'pdep','yes');
fprintf('T2013:\n')
pval13 = calcPvalVoxelWise(ansMat2013);
sigfdrt2013 =fdr_bh(pval13,0.05,'pdep','yes');
realt08 = ansMat2008(:,1);
realt13 = ansMat2013(:,1);
% set up figure
figure;
nr = 2; nc = 4;
cntplt = 1;
%pval old analyis
subplot(nr,nc,cntplt); cntplt = cntplt +1;
histogram(pval08);
title('pvals 08 ');

%pval new analysis
subplot(nr,nc,cntplt); cntplt = cntplt +1;
histogram(pval13);
title('pvals 13 ');

% plot real data vs real data
subplot(nr,nc,cntplt); cntplt = cntplt +1;
scatter(double(realt08),realt13);
xlabel('T2008');
ylabel('T2013');
rval = corrcoef([realt08,realt13],'rows','pairwise');
ttlstr = sprintf('T2013 (%d) vs T 2008 (%d) corr %.2f',...
    sum(sigfdrt2013),...
    sum(sigfdrt2008),...
    rval(1,2));
title(ttlstr);

% sorted pvals new vs old
subplot(nr,nc,cntplt); cntplt = cntplt +1;
hold on;
plot(sort(pval08),1:length(pval08));
plot(sort(pval13),1:length(pval13));
title('pvals 08 and 13');
legend({'08','13'});

% real 2008
subplot(nr,nc,cntplt); cntplt = cntplt +1;
histogram(ansMat2008(:,1));
title('real vals T 2008 ');

% shuf 2008
subplot(nr,nc,cntplt); cntplt = cntplt +1;
tmp = ansMat2008(:,2:end);
histogram(tmp(:));
title('shuf vals T 2008 ');

% real 2013
subplot(nr,nc,cntplt); cntplt = cntplt +1;
histogram(ansMat2013(:,1));
title('real vals T 2013 ');

% shuf 2013
subplot(nr,nc,cntplt); cntplt = cntplt +1;
tmp = ansMat2013(:,2:end);
histogram(tmp(:));
title('shuf vals T 2013 ');

end