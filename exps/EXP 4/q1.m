close all;

l = 5;
iterCount = power(2,l)-1;

%Generate two sequences
[h1,s1] = mSeq2([0 0 0 0 1],iterCount); % USER DEFINED function
[h2,s2] = mSeq1([1 1 1 0 0],iterCount);

for i=1:1:length(s1)
    if(s1(i) == 0)
        s1(i) = -1;
    end
    if(s2(i) == 0)
        s2(i) = -1;
    end
end
% Autocorrelation
d=(-iterCount+1):1:(iterCount-1);
autoCorr = zeros(1,length(d));
for i=1:1:length(d)
    autoCorr(i) = sum( s1.*circshift(s1,d(i)) )/iterCount;
end

figure(1)
%Plot auto correlation
plot(d,autoCorr)
title("Auto correlation of m-sequence with initial state 00001")
xlabel("d")
ylabel("Autocorrelation r(d)")
ylim([-1 2])
grid on;

% cross correlation
d=(-iterCount+1):1:(iterCount-1);
crossCorr = zeros(1,length(d));
for i=1:1:length(d)
    crossCorr(i) = sum( s1.*circshift(s2,d(i)) )/iterCount;
end

figure(2)
%Plot cross correlation
plot(d,crossCorr)
title("Cross correlation of two m-sequences with initial states 00001 & 11100")
xlabel("d")
ylabel("Cross correlation r(d)")
ylim([-1 2])
grid on;
