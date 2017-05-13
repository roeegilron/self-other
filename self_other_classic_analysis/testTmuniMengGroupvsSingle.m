function testTmuniMengGroupvsSingle()
x =  normrnd(0,0.1,[20,30]);
y =  normrnd(5,0.1,[20,30]);
cnt = 1;
for diff = linspace(1,0.5,20)
    for sig = linspace(1,5,20)
        x =  normrnd(0,sig,[20,30]);
        y =  normrnd(diff,sig,[20,30]);
        delta=x-y;
        told(cnt) = calcTstatMuniMeng([],delta);
        tnew(cnt) = calcTstatMuniMeng(x,y);
        cnt  = cnt + 1;
    end
end
figure;scatter(told,tnew)
xlabel('T 2008');
ylabel('T 2013');
title('comparison between Muni Mengs')
end