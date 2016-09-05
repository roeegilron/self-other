function plot_subject_performance_on_junk_trials(settings,params)
% plot the subject performance on junk trials 
for i = 1:length(settings.subsToUse)
    catchresp = [] ;
    corrrespo = [];
    rtofresp = [];
    for j = 1:4 % runs to use 
        fnm2load = sprintf('ObservationRun%d_Subject_%d.mat',...
            j,settings.subsToUse(i)); 
        subnum = settings.subsToUse(i);
        fullfnm  = fullfile('..',settings.behavdatafold,fnm2load);

        if exist(fullfnm,'file')
            load(fullfnm); 
            tbldt = struct2table(test_data);
            subresps = tbldt.sub_resp; 
            subprest = tbldt.subject;
            rtresp =   tbldt.response_time;
            corrress = double(subprest == subnum); % correct resp is 1 
            corrress(corrress==0) = 2;  % incorrect resp is 2 
            catchresp = [catchresp ; subresps(catchTrials==1)];
            corrrespo = [corrrespo ; corrress(catchTrials==1)];
            rtofresp = [rtofresp ;rtresp(catchTrials==1)];
        end
    end
    results.subnumbr(i) = subnum;
    results.percresp(i) = sum(catchresp>=1)/length(catchresp);% responded
    results.rtofresp{:,i} = rtofresp;
    idxuse = find(catchresp>=1);
    results.accofrsp(:,i) = sum(catchresp(idxuse)==corrrespo(idxuse))/length(idxuse);
    % of % responded, percent correct 
    % response time box plot
end
save(fullfile(settings.resfold,'behav_results_catch_trials.mat'),'results'); 
%% plot the behav reults 
hfig = figure('visible','off'); % fig for each subject
hfig.Position = get( groot, 'Screensize' )/2;

% plot the percent of subject resopnse 
subplot(2,2,1); 
hbar = bar(results.subnumbr,results.percresp);
title('subject attentiveness'); 
set(gca,'XTickLabelRotation',45);
ylabel('% catch trials sub responding'); 

% plot subject accuracy 
subplot(2,2,2); 
hbar = bar(results.subnumbr,results.accofrsp);
title('subject acc in catch trials'); 
set(gca,'XTickLabelRotation',45);
ylabel('% acc in catch trials'); 
x_loc = get(hbar, 'XData');
y_height = get(hbar, 'YData');
arrayfun(@(x,y) text(x-0.4, y-0.02,sprintf('%.2f',y), 'Color', 'y','FontSize',8),...
    x_loc, y_height);
set(gca,'FontSize',8)

% plot box plot of response times 
subplot(2,2,3); 
% create box plots 
x =[]; g = []; 
for i = 1:length(results.rtofresp)
    subnum = results.subnumbr(i); 
    vals = results.rtofresp{i}; 
    x = [x; vals]; 
    g = [g; repmat(subnum,length(vals),1)];
end
boxplot(x,g);
title('response times in catch trials'); 
ylabel('response times'); 
set(gca,'XTickLabelRotation',45);

% save figure 
fullfnmsv = fullfile('..',settings.figfold,'behav_results_catch_trials.pdf');
hfig.PaperPositionMode = 'auto';
hfig.Units = 'inches';
hfig.PaperOrientation = 'landscape';
hfig.PaperPosition = [.01 .01 [11 8.5]-0.01];
print(hfig,'-dpdf',fullfnmsv,'-opengl');
close(hfig);
end