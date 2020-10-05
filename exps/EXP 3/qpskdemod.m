clear all;
close all;

N = 2048; %Number of symbols
symbol_rate = 250; %symbols/second

x = randi([0 1],[1 2*N]); % Since two bits per symbols
x_nrz = 2*x - 1;

x_even = x_nrz(2:2:length(x));
x_odd = x_nrz(1:2:length(x));

x_constellation = x_odd + 1i.*x_even;
SNR = 10; % dB
x_noisy_symbols = x_constellation + (1/sqrt(2))*(1/sqrt(2)*10^(-SNR/20)) * randn(1,length(x_constellation)) + 1i * (1/sqrt(2))*(1/sqrt(2)*10^(-SNR/20)) * randn(1,length(x_constellation));

figure(1)
scatter(real(x_noisy_symbols),imag(x_noisy_symbols))
grid on
ylabel('Quadrature component')
xlabel('In-Phase Component')
title('QPSK in the presence of noise, SNR = 10 dB');


figure(2)
scatter(real(x_constellation),imag(x_constellation))
grid on
ylabel('Quadrature component')
xlabel('In-Phase Component')
axis([-2 2 -2 2])
title('QPSK in the absence of noise');
BER = [];
BER_analytical = [];
SNRs = 0:2:14;

for SNR = SNRs
    x = randi([0 1],[1 2*N]); % Since two bits per symbols
    x_nrz = 2*x - 1;

    x_even = x_nrz(2:2:length(x));
    x_odd = x_nrz(1:2:length(x));  
    x_constellation = x_odd + 1i.*x_even;
    
    x_noisy_symbols = x_constellation + (1/sqrt(2)*10^(-SNR/20)) * randn(1,length(x_constellation));%(1/sqrt(2))*(1/sqrt(2)*10^(-SNR/20)) * randn(1,length(x_constellation)) + 1i * (1/sqrt(2))*(1/sqrt(2)*10^(-SNR/20)) * randn(1,length(x_constellation));
    
    %Coherent Detection
    x_stream = [];
    for j = 1:1:length(x_noisy_symbols)
        x_stream = [x_stream,real(x_noisy_symbols(j)),imag(x_noisy_symbols(j))];
    end
    x_detected = zeros(1,length(x_stream));
    for j = 1:1:length(x_stream)
       if(x_stream(j)>0)
           x_detected(j) = 1;
       else
           x_detected(j) = 0;
       end
    end
    
    %BER calculation
    ber = 0;
    for k = 1:1:length(x_detected)
       if(x_detected(k)~=x(k))
          ber = ber + 1; 
       end
    end
    BER = [BER,ber/length(x)];
    BER_analytical = [BER_analytical,qfunc(sqrt(2*(10.^(SNR/10))))];
end
figure(3)
semilogy(SNRs,BER_analytical,'LineWidth',1.5)
hold on
semilogy(SNRs,BER,'O','LineWidth',1.5)
xlabel('Eb/No (dB)')
ylabel('BER')
title ('BER for QPSK')
legend('Analytical BER','Simulated BER')
grid on 


