function plotBehavResults()
[settings, params] = get_settings_params_encoding();
% get subjects that have behav result
fnstrc = dir(fullfile(settings.behavdata,'BehavExpData_*.mat'));
x = []; 
gr = []; 
grnpb = [] ; 

for s = 1:length(fnstrc)
    fnm = fullfile(settings.behavdata, fnstrc(s).name);    
    load(fnm);
    [~,fn] = fileparts(fnm);
    subnm = str2num(fn(17:20));
    
    % 600 = aronit , 601 = rashamkol, 602 = traklin
    conds = [ 600, 601, 602];
    labelsc = ['a','r','t'];
    dataTable = struct2table(testData);
    
    % compute distnace mat
    cnt = 1;
    x = [];
    gr = [];
    grnpb = [] ;
    for s = 1:2 % 1 = self , 2 = other
        for c = 1:length(conds) % conds
            label(2) = labelsc(c);
            idxcond = dataTable.cond == conds(c);
            if s == 1
                idxsub = dataTable.subject == subnm;
                label(1) = 'S';
            else
                idxsub = dataTable.subject ~= subnm;
                label(1) = 'O';
            end
            datadd = dataTable.sub_resp(idxcond & idxsub);
            x = [x; datadd];
            gr = [gr ;repmat(label,length(datadd),1)];
            grnpb = [grnpb ;repmat(cnt,length(datadd),1)];

            results.Raw.(label) = dataTable.sub_resp(idxcond & idxsub);
            results.Mean(cnt) = mean(dataTable.sub_resp(idxcond & idxsub));
            results.Median(cnt) = median(dataTable.sub_resp(idxcond & idxsub));
            results.medianrt(cnt) = median(dataTable.response_time(idxcond & idxsub));
            results.Variance(cnt) = std(dataTable.sub_resp(idxcond & idxsub))/sqrt(sum(idxcond & idxsub));
            results.labels{cnt} = label;
            labelsUse{cnt} = label;
            cnt = cnt + 1;
        end
    end
    distances.mean     = pdist(results.Mean');
    distances.median   = pdist(results.Median');
    distances.variance = pdist(results.medianrt');
    distances.medianrt = pdist(results.Variance');
    distances.labels   = labelsUse;

    %% plot figures for each subject
    hfig = figure('Position',[283         660        2126         678],'Visible','off');
    nrows = 2; ncol = 4; pltcnt = 1; 
    % plot boxplt plot 
    subplot(nrows,ncol,pltcnt); pltcnt = pltcnt + 1; 
    notBoxPlot(x,grnpb)
    set(gca,'XTickLabel',labelsUse);
    title(sprintf('%d',subnm));
    ylabel('sub rating');
    set(findall(hfig,'-property','FontSize'),'FontSize',16)
    
    %% plot acc 4 is is miss miss  
    % 600 = aronit , 601 = rashamkol, 602 = traklin
    subplot(nrows,ncol,pltcnt); pltcnt = pltcnt + 1;
    cr = zeros(length(dataTable.subject),1); % correct response 
    ident.idxself = dataTable.subject == subnm;
    ident.idxothr = dataTable.subject ~= subnm;
    cr(ident.idxself) = 1; 
    cr(ident.idxothr) = 2; 
    sr = zeros(length(dataTable.sub_resp),1); %subject response 
    sr(dataTable.sub_resp <= 40) = 1; 
    sr(dataTable.sub_resp > 40)  = 2; 
    % conds 
    condidx.idxar   = dataTable.cond == 600;
    condidx.idxrs   = dataTable.cond == 601;
    condidx.idxtr   = dataTable.cond == 602;
    
    condnams = fieldnames(condidx); 
    identnam = fieldnames(ident);
    cntacc = 1; 
    for i = 1:length(identnam)
        for c = 1:length(condnams)
            idxus = condidx.(condnams{c}) & ident.(identnam{i});
            accbyword(cntacc) = sum(cr(idxus) == sr(idxus)) / sum(idxus);
            cntacc = cntacc + 1; 
        end
    end
    bar(accbyword); 
    set(gca,'XTickLabel',labelsUse);
    ylabel('accuracy');
    xlabel('word seen'); 
    title(sprintf('acc 4 = miss %d',subnm));
    set(findall(hfig,'-property','FontSize'),'FontSize',16)

    
    %% plot accuracy  without 4 
    subplot(nrows,ncol,pltcnt); pltcnt = pltcnt + 1;
    
    condsraw = dataTable.cond; 
    subresraw = dataTable.sub_resp; 
    subjetsraw = dataTable.subject; 
    idx40 = dataTable.sub_resp == 40;  
    condsuse   =  dataTable.cond(~idx40);
    subresuse  =  dataTable.sub_resp(~idx40);
    subjectuse =  dataTable.subject(~idx40);
   
    cr = zeros(length(subjectuse),1); % correct response 
    ident.idxself = subjectuse == subnm;
    ident.idxothr = subjectuse ~= subnm;
    cr(ident.idxself) = 1; 
    cr(ident.idxothr) = 2; 
    sr = zeros(length(subresuse),1); %subject response 
    sr(subresuse <= 40) = 1; 
    sr(subresuse > 40)  = 2; 
    % conds 
    condidx.idxar   = condsuse == 600;
    condidx.idxrs   = condsuse == 601;
    condidx.idxtr   = condsuse == 602;
    
    condnams = fieldnames(condidx); 
    identnam = fieldnames(ident);
    cntacc = 1; 
    for i = 1:length(identnam)
        for c = 1:length(condnams)
            idxus = condidx.(condnams{c}) & ident.(identnam{i});
            accbyword(cntacc) = sum(cr(idxus) == sr(idxus)) / sum(idxus);
            cntacc = cntacc + 1; 
        end
    end
    bar(accbyword); 
    set(gca,'XTickLabel',labelsUse);
    ylabel('accuracy');
    xlabel('word seen'); 
    title(sprintf('acc (delete 4s) %d',subnm));
    set(findall(hfig,'-property','FontSize'),'FontSize',16)

    %% plot variance in answers 
    subplot(nrows,ncol,pltcnt); pltcnt = pltcnt + 1;
    cr = zeros(length(dataTable.subject),1); % correct response 
    ident.idxself = dataTable.subject == subnm;
    ident.idxothr = dataTable.subject ~= subnm;
    cr(ident.idxself) = 1; 
    cr(ident.idxothr) = 2; 
    sr = zeros(length(dataTable.sub_resp),1); %subject response 
    sr(dataTable.sub_resp <= 40) = 1; 
    sr(dataTable.sub_resp > 40)  = 2; 
    % conds 
    condidx.idxar   = dataTable.cond == 600;
    condidx.idxrs   = dataTable.cond == 601;
    condidx.idxtr   = dataTable.cond == 602;
    
    condnams = fieldnames(condidx); 
    identnam = fieldnames(ident);
    cntacc = 1; 
    for i = 1:length(identnam)
        for c = 1:length(condnams)
            idxus = condidx.(condnams{c}) & ident.(identnam{i});
            variancesplot(cntacc) = var(dataTable.sub_resp( idxus));
            cntacc = cntacc + 1; 
        end
    end
    bar(variancesplot); 
    set(gca,'XTickLabel',labelsUse);
    ylabel('variance');
    xlabel('word seen'); 
    title(sprintf('variance %d',subnm));
    set(findall(hfig,'-property','FontSize'),'FontSize',16)

    %% plot distances in plot 
    distncplot = {'mean','median','variance','medianrt'};
    for p = 1:length(distncplot)
        subplot(nrows,ncol,pltcnt); pltcnt = pltcnt + 1;
        imagesc(squareform(distances.(distncplot{p})));
        colorbar;
        title(sprintf('%s D %d',distncplot{p},subnm));
        set(gca,'YTickLabel',distances.labels)
        set(gca,'XTickLabel',distances.labels)
        set(findall(hfig,'-property','FontSize'),'FontSize',16)
    end
    suptitle(sprintf('subject %d',subnm))
    fnm = sprintf('s%d.jpeg',subnm); 
    fnmsv = fullfile(settings.figbehavdata,fnm);
    hfig.PaperPositionMode = 'auto';
    print(hfig,'-djpeg',fnmsv,'-opengl','-r300');
    close(hfig); 
end






end