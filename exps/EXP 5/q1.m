close all;

N = 10000;
qam1Symbols = randsrc(1,N,[-3+1i,-1+1i, 1+1i,3+1i,-3-1i,-1-1i, 1-1i,3-1i]);
qam2Symbols = randsrc(1,N,[1,(1/sqrt(2))+(1i/sqrt(2)),1i,(-1/sqrt(2))+(1i/sqrt(2)),-1,(-1/sqrt(2))-(1i/sqrt(2)),-1i,(1/sqrt(2))-(1i/sqrt(2))]);
qam3Symbols = randsrc(1,N,[(1/sqrt(2))+(1i/sqrt(2)),-(1/sqrt(2))+(1i/sqrt(2)),-(1/sqrt(2))-(1i/sqrt(2)),(1/sqrt(2))-(1i/sqrt(2)), 1+sqrt(3),(1+sqrt(3))*1i,-(1+sqrt(3)),-(1+sqrt(3))*1i]);

figure(1)
scatter(real(qam1Symbols),imag(qam1Symbols),'filled')
title("Rectangular 8-QAM Constellation")
xlabel("In phase component")
ylabel("Quadrature component")
axis([-4 4 -4 4])

figure(2)
scatter(real(qam2Symbols),imag(qam2Symbols),'filled')
title("Circular-1 8-QAM Constellation")
xlabel("In phase component")
ylabel("Quadrature component")
axis([-4 4 -4 4])

figure(3)
scatter(real(qam3Symbols),imag(qam3Symbols),'filled')
title("Circular-2 8-QAM Constellation")
xlabel("In phase component")
ylabel("Quadrature component")
axis([-4 4 -4 4])

