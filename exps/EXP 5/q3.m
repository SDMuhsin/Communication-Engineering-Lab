clear all;
N = 200000;
close all;
SNR = [4,6,8,10,12,14,16];
qam1Distinct = [-3+1i,-1+1i, 1+1i,3+1i,-3-1i,-1-1i, 1-1i,3-1i];
qam2Distinct = [1,(1/sqrt(2))+(1i/sqrt(2)),1i,(-1/sqrt(2))+(1i/sqrt(2)),-1,(-1/sqrt(2))-(1i/sqrt(2)),-1i,(1/sqrt(2))-(1i/sqrt(2))];
qam3Distinct = [(1/sqrt(2))+(1i/sqrt(2)),-(1/sqrt(2))+(1i/sqrt(2)),-(1/sqrt(2))-(1i/sqrt(2)),(1/sqrt(2))-(1i/sqrt(2)), 1+sqrt(3),(1+sqrt(3))*1i,-(1+sqrt(3)),-(1+sqrt(3))*1i];

qam1Error = zeros(1,length(SNR));
qam2Error = zeros(1,length(SNR));
qam3Error = zeros(1,length(SNR));

qam1ErrorSim = zeros(1,length(SNR));
qam2ErrorSim = zeros(1,length(SNR));
qam3ErrorSim = zeros(1,length(SNR));
for SNR_index = 1:1:length(SNR)
    
    %Generate Symbols
    qam1Symbols = randsrc(1,N,[-3+1i,-1+1i, 1+1i,3+1i,-3-1i,-1-1i, 1-1i,3-1i]);
    qam2Symbols = randsrc(1,N,[1,(1/sqrt(2))+(1i/sqrt(2)),1i,(-1/sqrt(2))+(1i/sqrt(2)),-1,(-1/sqrt(2))-(1i/sqrt(2)),-1i,(1/sqrt(2))-(1i/sqrt(2))]);
    qam3Symbols = randsrc(1,N,[(1/sqrt(2))+(1i/sqrt(2)),-(1/sqrt(2))+(1i/sqrt(2)),-(1/sqrt(2))-(1i/sqrt(2)),(1/sqrt(2))-(1i/sqrt(2)), 1+sqrt(3),(1+sqrt(3))*1i,-(1+sqrt(3)),-(1+sqrt(3))*1i]);
    

    %Add AWGN
    qam1SymbolsNoisy = qam1Symbols + (1/sqrt(2))*1/sqrt(2)*10^(-SNR(SNR_index)/20) * randn(1,N)+(1i/sqrt(2))*1/sqrt(2)*10^(-SNR(SNR_index)/20) * randn(1,N);
    qam2SymbolsNoisy = qam2Symbols + (1/sqrt(2))*1/sqrt(2)*10^(-SNR(SNR_index)/20) * randn(1,N)+(1i/sqrt(2))*1/sqrt(2)*10^(-SNR(SNR_index)/20) * randn(1,N);
    qam3SymbolsNoisy = qam3Symbols + (1/sqrt(2))*1/sqrt(2)*10^(-SNR(SNR_index)/20) * randn(1,N)+(1i/sqrt(2))*1/sqrt(2)*10^(-SNR(SNR_index)/20) * randn(1,N);

    if(SNR_index == 1)
        figure(1)
       scatter(real(qam1SymbolsNoisy),imag(qam1SymbolsNoisy))
       title("rect")
       figure(2)
       scatter(real(qam2SymbolsNoisy),imag(qam2SymbolsNoisy))
       title("circular 1")
       figure(3)
       scatter(real(qam3SymbolsNoisy),imag(qam3SymbolsNoisy))
       title("circular 2")
    end
    %Detection
    qam1Detected = zeros(1,N);
    qam2Detected = zeros(1,N);
    qam3Detected = zeros(1,N);
    
    %Circular 1 and 2  
    for i=1:1:N
        qam1ArgMin = 1;
        qam1Min = abs(qam1SymbolsNoisy(i)-qam1Distinct(1));
        
        qam2ArgMin = 1;
        qam2Min = abs(qam2SymbolsNoisy(i)-qam2Distinct(1));

        qam3ArgMin = 1;
        qam3Min = abs(qam3SymbolsNoisy(i)-qam3Distinct(1));
        
        for j=2:1:length(qam2Distinct)

            if(abs( qam1SymbolsNoisy(i) - qam1Distinct(j)) < qam1Min )
               qam1ArgMin = j;
               qam1Min = abs( qam1SymbolsNoisy(i) - qam1Distinct(j));
            end
            
            if(abs( qam2SymbolsNoisy(i) - qam2Distinct(j)) < qam2Min )
               qam2ArgMin = j;
               qam2Min = abs( qam2SymbolsNoisy(i) - qam2Distinct(j));
            end
            
            if(abs( qam3SymbolsNoisy(i) - qam3Distinct(j)) < qam3Min )
               qam3ArgMin = j;
               qam3Min = abs( qam3SymbolsNoisy(i) - qam3Distinct(j));
            end
        end
        
        qam1Detected(i) = qam1Distinct(qam1ArgMin);
        qam2Detected(i) = qam2Distinct(qam2ArgMin);
        qam3Detected(i) = qam3Distinct(qam3ArgMin);
        

    end
  
        
   
    
    %Error
    e1 = 0;
    e2 = 0;
    e3 = 0;

    for i=1:1:N
       if(qam1Detected(i) ~= qam1Symbols(i))
            e1 = e1+1;
       end
       
       if(qam2Detected(i) ~= qam2Symbols(i))
            e2 = e2+1;
       end
       
       if(qam3Detected(i) ~= qam3Symbols(i))
            e3 = e3+1;
       end
    end
    qam1Error(SNR_index) = e1/N;
    qam2Error(SNR_index)  = e2/N;
    qam3Error(SNR_index) = e3/N;
    
    snr = 10^(SNR(SNR_index)/10);
    disp(snr);
    %qam1ErrorSim(SNR_index) = 4*qfunc(sqrt((3*3*snr/3)/(7)));
    qam1ErrorSim(SNR_index) = 2*(1-1/sqrt(8))*erfc(3*sqrt(snr))-(1-(2/sqrt(8))+1/8)*power(erfc(3*sqrt(snr)),2);
    qam2ErrorSim(SNR_index)  = qfunc(sqrt(2*SNR(SNR_index)*3*power(sin(pi/8),2)));
    %qam3ErrorSim(SNR_index) = 4*qfunc(sqrt(2*snr));
end
figure(4)
semilogy(SNR,qam2Error,'LineWidth',1.5)
hold on
semilogy(SNR,qam2ErrorSim,'LineWidth',1.5)
%hold on
%semilogy(SNR,qam3ErrorSim,'LineWidth',1.5)
xlabel('E_{s}/No (dB)')
ylabel('Symbol Error')
title (' Rectangular QAM symbol Error')
legend('Simulated Error ','Analytically Computed Error')
grid on 

