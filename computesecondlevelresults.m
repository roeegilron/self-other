function computesecondlevelresults(settings,params) 
subdirs = findFilesBVQX(settings.resfolder,[settings.subprefr '*'],...
    struct('dirs',1,'maxdepth',1));
roinams = findFilesBVQX(subdirs{1},['*.mat'],...
    struct('maxdepth',1));

for i = 1:length(roinams)% loop on roinames  
    [pn, roifn] = fileparts(roinams{i});
    start = tic;
    for j = 1:length(subdirs) % loop on subjects 
        load(fullfile(subdirs{j},[roifn '.mat']),'ansmat');
        ansmat_allsubs(j,:) = ansmat;
        clear ansmat; 
    end
    ansmat = compute_stelzer_perms(ansmat_allsubs,params);
    % plot figs of shufs 
    plot_sec_level_shuf(ansmat,ansmat_allsubs,roifn(5:end),settings,params);    
    resfold = fullfile(settings.resfolder,settings.grpfolder);
    evalc('mkdir(resfold)'); % suprress warning 
    fnmsv = sprintf('res_group_%s_%d_shufs_%d_stlzershufs_%s_avg_mode.mat',...
        roifn(5:end),params.numshufs,params.stlzrshuf,params.avgtype);
    save(fullfile(resfold,fnmsv),'ansmat','params');
    fprintf('finished roi %s in %f\n',roifn(5:end),toc(start));
end

end

function hfig = plot_sec_level_shuf(ansmat,ansmat_allsubs,roifn,settings,params)
real_dat = ansmat_allsubs(:,1); 
shuf_dat = ansmat_allsubs(:,2:end);
violindat{1} = real_dat; violindat{2} = shuf_dat;
labels = {'Real T', 'Shuf T'}; 
pvals = calcPvalVoxelWise(ansmat_allsubs); 
hfig = figure('Position',[317         347        1562         862]); 
% real vs shuff before stelzer - violin 
[data, labels] = grammify(real_dat,'Real T',shuf_dat(:),'Shuf T'); 
g(1,1) = gramm('x',labels,'y',data,'color',labels); 
g(1,2) = copy(g(1)); 
g(1,3) = gramm('x',data,'color',labels); 
g(2,1) = gramm('x',1:length(pvals),'y',sort(pvals)); 
[data, labels] = grammify(repmat(ansmat(1),100,1),'Real Group T',ansmat(2:end)','Stelzer Shuf T'); 
g(2,2) = gramm('x',data,'color',labels); 

g(1,1).stat_violin;
g(1,1).set_names('y','T Values'); 
g(1,1).set_title('Real Vs Shuf b4 Stelzer'); 

% real vs shuff before stelzer - boxplot 
g(1,2).stat_boxplot();
g(1,2).set_names('y','T Values'); 
g(1,2).set_title('Real Vs Shuf b4 Stelzer'); 

% real vs shuff before stelzer - histogram  
g(1,3).stat_bin('nbins',50,'normalization','probability','geom','overlaid_bar');
g(1,3).set_names('y','T Values'); 
g(1,3).set_title('Real Vs Shuf b4 Stelzer'); 

% pvals bars 
g(2,1).geom_bar()
g(2,1).set_names('y','P-Values','x','subjects #'); 
g(2,1).set_title('Individual Sub p-vals'); 

%stelzer histogam 
g(2,2).stat_bin('nbins',50,'geom','overlaid_bar')
g(2,2).set_names('y','probability','x','Stelzer Shuf T values'); 
pvalstlzer = calcPvalVoxelWise(ansmat);
g(2,2).set_title(sprintf('Stelzer Sub p-vals (%.3f)',pvalstlzer)); 

g.set_title(strrep(roifn,'_',' '));

g.draw; 
g(1,1).update();
g(1,2).update();
g(1,3).update();
g(2,1).update();
g(2,2).update();

% hold on; 
% scatter(ansmat(1),0,20,'b','filled');


fnmsv = sprintf('shuf_analysis_%d_shufs_%d_stlzer_shufs_%s_avg_type_%s.pdf',...
    params.numshufs,params.stlzrshuf,params.avgtype,roifn);
fullfnmsv = fullfile(settings.figfolder,fnmsv);
hfig.PaperPositionMode = 'auto';
hfig.Units = 'inches';
hfig.PaperOrientation = 'landscape';
hfig.PaperPosition = [.01 .01 [11 8.5]-0.01];
print(hfig,'-dpdf',fullfnmsv);
close(hfig);




end

function [data,labels] = grammify(varargin)
data = []; 
labels = {}; 
for i = 1:length(varargin)
    if mod(i,2) == 0 
        labels = [labels; repmat({varargin{i}},length(varargin{i-1}),1)];
    else
        data = [data ; varargin{i}];
    end
end
end
