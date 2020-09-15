f = 1000;
t = 0:1/100000:10/f;

x = cos(2 * pi * f * t);
subplot(211)
plot(t,x),title("f = "+f),xlabel("time(s)"),ylabel("Amplitude");

i = 2;
for fs = [200]
    to = 0:1/10000:20/f;
    xo = cos( 2 * pi * f * to);
    
    t = 0:1/fs:20/f;
    x = cos( 2 * pi * f * t);
    
    subplot(2,1,i)
    plot(to,xo, "green"),hold on;
    stem(t,x),title( " fs = " + fs),xlabel("time(s)"),ylabel("Amplitude");
    i = i+1;
    
    
    t = 0:1/fs:99/fs;
    x = cos( 2 * pi * f * t);
 
end