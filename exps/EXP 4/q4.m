%Matlab file used for class demo conducted during Session 3
%on the use of cross-correlation .
%A word utterance is effectively sampled at four different
%rates and played back to hear the effects of aliasing
set(0,'defaultaxesfontsize',20);
clear
clf
%Use Walsh-Hadamard sequences as orthogonal codes
clength=64;
lag=0:(2*clength-2);
C=hadamard(clength);
code1=C(1,:);
code2=C(2,:);
code3=C(3,:);
%Plot autocorrelation of code 1, and cross-correlation
%between code 1 and code 2
plot(lag,conv(code1,code1(end:-1:1)),'Linewidth',3)
print -deps MAI
xlabel('lag value')
hold on
plot(lag,conv(code1,code2(end:-1:1)),'r','Linewidth',3)
legend('Autocorrelation of Code 1','Cross-correlation between Code 1 and Code 2')
hold off
pause
%Plot autocorrelation of code 2, and cross-correlation
%between code 2 and code 3
plot(lag,conv(code2,code2(end:-1:1)),'Linewidth',3)
xlabel('lag value')
hold on
plot(lag,conv(code2,code3(end:-1:1)),'r','Linewidth',3)
legend('Autocorrelation of Code 2','Cross-correlation between Code 2 and Code 3')
hold off
pause
%generate length 4 bit sequences for each of
%three different users:
%represent data bit "1" as amplitude 1
%represent data bit "0" as amplitude -1
bit1=[1 1 1 1];
bit2=[1 1 -1 -1];
bit3=[1 -1 1 -1];
%synthesize CDMA signal for each user and then
%sum (superimpose) the three users' signals
%do a help on kron.m to understand what it does
x=kron(bit1,code1)+kron(bit2,code2)+kron(bit3,code3);
plot(x,'Linewidth',3)
xlabel('Sum signal -- three users superimposed')
pause
y1=conv(x,code1(end:-1:1));
plot(y1,'Linewidth',3)
xlabel('cross-correlation with Walsh code 1 -- bits: 1,1,1,1')
pause
stem(0:3,y1(64:64:end)/64)
axis([0 3 -1 1])
xlabel('cross-correlation with Walsh code 1 -- bits: 1,1,1,1')
pause
y2=conv(x,code2(end:-1:1));
plot(y2,'Linewidth',3)
xlabel('cross-correlation with Walsh code 2 -- bits: 1,1,-1,-1')
pause
stem(0:3,y2(64:64:end)/64)
axis([0 3 -1 1])
xlabel('cross-correlation with Walsh code 2 -- bits: 1,1,-1,-1')
pause
y3=conv(x,code3(end:-1:1));
plot(y3,'Linewidth',3)
xlabel('cross-correlation with Walsh code 3 -- bits: 1,-1,1,-1')
pause
stem(0:3,y3(64:64:end)/64)
axis([0 3 -1 1])
xlabel('cross-correlation with Walsh code 3 -- bits: 1,-1,1,-1')

