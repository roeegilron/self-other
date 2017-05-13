resdir = 'D:\Roee_Main_Folder\1_AnalysisFiles\Poldrack_RFX\matlabCode\results_VocalDataSet_FFX_ND_norm_REAL_PARINGS_SL9_SVM';

ff = findFilesBVQX(resdir,'res*.mat');
labelspairdings = {'orig-p','max-anti-cor', 'randperm1','randperm2'};
for k = 1:length(ff)
    load(ff{k},'ansMat','ansMatOld','ansMatSVM');
    [pn,fn] = fileparts(ff{k});
    % t08
    hfig = figure;
    fns = fullfile(resdir,sprintf('s%s-T08.jpeg',fn(50:52)));
    suptitle('T08');
    for i = 1:4;
        subplot(2,2,i);
        histogram(ansMatOld(:,i,1));
        title(labelspairdings{i});
        xlabel('stat val');
        ylabel('count');
        xlim([-2 2]);
    end
    hfig.PaperPositionMode = 'auto';
    print(fns,'-djpeg','-r300')
    close(hfig);
    
    % t13
    hfig = figure;
    fns = fullfile(resdir,sprintf('s%s-T13.jpeg',fn(50:52)));
    suptitle('T13');
    for i = 1:4;
        subplot(2,2,i);
        histogram(ansMat(:,i,1));
        title(labelspairdings{i});
        xlabel('stat val');
        ylabel('count');
        xlim([-2 2]);
    end
    hfig.PaperPositionMode = 'auto';
    print(fns,'-djpeg','-r300')
    close(hfig);
    
    % svm
    hfig = figure;
    fns = fullfile(resdir,sprintf('s%s-SVM.jpeg',fn(50:52)));
    suptitle('SVM');
    for i = 1:4;
        subplot(2,2,i);
        histogram(ansMatSVM(:,i,1));
        title(labelspairdings{i});
        xlabel('stat val');
        ylabel('count');
        xlim([0 1]);
    end
    hfig.PaperPositionMode = 'auto';
    print(fns,'-djpeg','-r300')
    close(hfig);
end