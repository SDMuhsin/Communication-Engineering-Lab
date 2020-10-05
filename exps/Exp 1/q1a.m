clc;
clear all;
close all;

N = 1024; %No: of 1 bit symbols
c = [-1 1]; %valid symbols
xmod = randsrc(1,N,c); %Random sequence of 1s and 2s


scatterplot(xmod),title("1024 BPSK Symbols"),grid on,xlim([-2 2]);

%Add AWGN
i = 1;
for SNR = [5 10 15 20]
    xmod_noised = awgn(complex(xmod),SNR);
    scatterplot(xmod_noised,20),title("1024 BPSK Symbols with AWGN, SNR ="+SNR),grid on,xlim([-2 2]);
    i = i + 1;
end

%Coherent detection'
for i = 1:1:length(xmod_noised)
    if(xmod_noised(i)>0)
        x_detected(i) = 1;
    else
        x_detected(i) = -1;
    end
end

%Bit Error Rate
x_detected = zeros(1,N);
SNR = 0:2:14;
index = 1:1:length(SNR);
BER = zeros(1,length(SNR));
BER_analytical = zeros(1,length(SNR));
for SNR_index = index
    %xmod_noised = awgn(complex(xmod),SNR(SNR_index));
    xmod_noised = xmod + 1/sqrt(2)*10^(-SNR(SNR_index)/20) * randn(1,N);
    %detect
    for i = 1:1:length(xmod_noised)
        if(xmod_noised(i)>0)
            x_detected(i) = 1;
        else
            x_detected(i) = -1;
        end
    end
    
    %biterror
    for i = 1:1:length(xmod_noised)
        if x_detected(i) ~= xmod(i)
            BER(SNR_index) = BER(SNR_index) + 1;
        end
    end
    BER(SNR_index) = BER(SNR_index)/N;
    BER_analytical(SNR_index) = qfunc(sqrt(2*(10.^(SNR(SNR_index)./10))));
end

%SNR = 10.^(SNR./10);
semilogy(SNR,BER_analytical,'LineWidth',1.5)
hold on
semilogy(SNR,BER,'O','LineWidth',1.5)
xlabel('Eb/No (dB)')
ylabel('BER')
title ('BER for BPSK')
legend('Analytical BER','Simulated BER')
grid on 
