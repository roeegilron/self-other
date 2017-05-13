function plotChanceOfSelectingSame()

percent = [1 : -0.1 : 0.7];
figure;
for j = 1:length(percent)
    cnt =1 ; prob = [];
    for i = 13:2:30;
        prob(cnt) = ((nchoosek(i,floor(i*(percent(j)))))/(2^i))/(1/1e3);
        cnt = cnt + 1;
    end
    ttl = sprintf('Probability of selecting %%%d of subjects in 1000 shuffels',...
        percent(j)*100);
    subplot(2,2,j);
    plot( 13:2:30,prob);
    title(ttl);
    xlabel('Number Of Subjects' )
    ylabel('Number of Times Selection Expected'); 
end

end