function drawXandEqualityLine()
xlim = get(gca,'xlim');
ylim = get(gca,'ylim');

% draw x through zero zero 
line([0 0], ylim,'Color',[0 0 0]);
line(xlim, [0 0],'Color',[0 0 0]);

%draw equaliy line 
line(xlim, ylim,'Color',[1 0 0]);
end