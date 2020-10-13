clear all;
close all;

W = [1 1;1 -1];

n = 5; %log2(32)
for i = 2:1:n
   W = [W, W; W, -1*W];
end


% Autocorrelation
iterCount = power(2,n);
s1 = W(3,1:end);

d=2*(-iterCount+1):1:2*(iterCount-1);
autoCorr = zeros(1,length(d));
for i=1:1:length(d)
    autoCorr(i) = sum( s1.*circshift(s1,d(i)) )/iterCount;
end

figure(1)
%Plot auto correlation
plot(d,autoCorr)
title("Auto Correlation of a 32 length walsh sequence")
xlabel("d")
ylabel("Auto correlation r(d)")
ylim([-2 2])
grid on;

s2 = W(5,1:end);
crossCorr = zeros(1,length(d));
for i=1:1:length(d)
    crossCorr(i) = sum( s1.*circshift(s2,d(i)) )/iterCount;
end

figure(2)
%Plot cross correlation
plot(d,crossCorr)
title("Cross correlation of two 32 length Walsh sequences")
xlabel("d")
ylabel("Cross correlation r(d)")
ylim([-2 2])
grid on;

