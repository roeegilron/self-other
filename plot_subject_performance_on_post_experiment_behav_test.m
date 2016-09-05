function plot_subject_performance_on_post_experiment_behav_test(settings,params)
% plot the subject performance on junk trials
cnt = 1;
for i = 1:length(settings.subsToUse)
    catchresp = [] ;
    corrrespo = [];
    rtofresp = [];
    fnm2load = sprintf('BehavExpData*%d*.mat',...
        settings.subsToUse(i));
    subnum = settings.subsToUse(i);
    foundfile = findFilesBVQX(fullfile('..',settings.behavdatafold),fnm2load);
    
    if ~isempty(foundfile)
        load(foundfile{1});
        tbldt = struct2table(testData);
        subresps = tbldt.sub_resp;
        subprest = tbldt.subject;
        rtresp =   tbldt.response_time;
        corrress = double(subprest == subnum); % correct resp is 1
        corrress(corrress==0) = 2;  % incorrect resp is 2
        behavresp = double(subresps<=30);
        behavresp(behavresp==0) = 2;
        corrrespo = corrress;
        rtofresp = rtresp;
        results.subnumbr(cnt) = subnum;
        results.percresp(cnt) = sum(subresps==40)/length(subresps);% responded
        results.rtofresp{:,cnt} = rtofresp;
        results.accofrsp(:,cnt) = sum(behavresp==corrrespo)/length(corrrespo);
        cnt = cnt + 1;
    end
    % of % responded, percent correct
    % response time box plot
end
save(fullfile(settings.resfold,'behav_results_after_exper.mat'),'results');
%% plot the behav reults
hfig = figure('visible','on'); % fig for each subject
hfig.Position = get( groot, 'Screensize' )/2;

% plot the percent of subject resopnse
subplot(2,2,1);
hbar = bar(results.subnumbr,results.percresp);
title('subject guesses out of total');
set(gca,'XTickLabelRotation',45);
ylabel('% subject guesing out (4) out of total');

% plot subject accuracy
subplot(2,2,2);
hbar = bar(results.subnumbr,results.accofrsp);
title('subject acc in catch trials');
set(gca,'XTickLabelRotation',45);
ylabel('% acc in trials post experiment');
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
fullfnmsv = fullfile('..',settings.figfold,'behav_results_post_experiment.pdf');
hfig.PaperPositionMode = 'auto';
hfig.Units = 'inches';
hfig.PaperOrientation = 'landscape';
hfig.PaperPosition = [.01 .01 [11 8.5]-0.01];
print(hfig,'-dpdf',fullfnmsv,'-opengl');
close(hfig);
end