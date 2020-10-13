clear all;
close all;

l = 5;
iterCount = power(2,l)-1;

%Generate two m-sequences of length 5
[h1,s1] = mSeq1([0 0 0 0 1],iterCount); % USER DEFINED functions
[h2,s2] = mSeq2([0 0 1 0 1],iterCount);

gold = int8(xor(s1,s2));

for i=1:1:length(gold)
    if(gold(i) == 0)
        gold(i) = -1;
        
    end
end

% Autocorrelation
d=-iterCount+1:1:(iterCount-1);
autoCorr = zeros(1,length(d));
for i=1:1:length(d)
    autoCorr(i) = sum( gold.*circshift(gold,d(i)) )/iterCount;
end

figure(1)
%Plot auto correlation
plot(d,autoCorr)
title("Auto correlation of gold-sequence with m-sequences 1+x^2+x^3+x^4+x^5 and 1+x^2+x^5")
xlabel("d")
ylabel("Autocorrelation r(d)")
%ylim([-1 2])
grid on;

% cross correlation
[h1,s1] = mSeq1([0 0 0 0 1],iterCount); % USER DEFINED functions
[h2,s2] = mSeq2([1 0 1 1 1],iterCount);

gold2 = int8(xor(s1,s2));

for i=1:1:length(gold)
    if(gold2(i) == 0)
        gold2(i) = -1;
        
    end
end

d=2*(-iterCount+1):1:2*(iterCount-1);
crossCorr = zeros(1,length(d));
for i=1:1:length(d)
    crossCorr(i) = sum( gold.*circshift(gold2,d(i)) )/iterCount;
end

figure(2)
%Plot cross correlation
plot(d,crossCorr)
title("Cross correlation of two gold-sequences with initial states(of second m sequences) 00001 & 10111")
xlabel("d")
ylabel("Cross correlation r(d)")
ylim([-1 2])
grid on;
