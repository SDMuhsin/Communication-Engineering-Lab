clear all;
close all;

N = 64; %Number of symbols
f = 1000; %carrier frequency
symbol_rate = 2500; %symbols/second

x = randi([0 1],[1 N]); % Since two bits per symbols
%x_nrz = 2*x - 1;
x_nrz = x;

x_even = x_nrz(2:2:length(x));
x_odd = x_nrz(1:2:length(x));

%x_constellation = x_odd + 1i.*x_even;
qp = comm.QPSKModulator('PhaseOffset',0,'BitInput',true);
x_constellation = qp(transpose(x));

SNR = 10; % dB
x_noisy_symbols = x_constellation + (1/sqrt(2))*(1/sqrt(2)*10^(-SNR/20)) * randn(1,length(x_constellation)) + 1i * (1/sqrt(2))*(1/sqrt(2)*10^(-SNR/20)) * randn(1,length(x_constellation));


%Pulse shaping
span = 10; % Filter span in symbols
rolloff = 0.35; % Rolloff factor
nSamp = 8*symbol_rate;
SNR = 10;

txfilter = comm.RaisedCosineTransmitFilter('Shape','Square root','RolloffFactor',rolloff, 'FilterSpanInSymbols',span,'OutputSamplesPerSymbol',nSamp);
txSig = txfilter(x_constellation);

%awgn
txSig = awgn(txSig,SNR,'measured');
%txSig = txSig + (1/sqrt(2))*(1/sqrt(2)*10^(-SNR/20)) * randn(nSamp,N) + 1i * (1/sqrt(2))*(1/sqrt(2)*10^(-SNR/20)) * randn(nSamp,N);

%Recieve
rxfilter = comm.RaisedCosineReceiveFilter('Shape','Square root','RolloffFactor',rolloff, 'FilterSpanInSymbols',span,'InputSamplesPerSymbol',nSamp);
rxSig = rxfilter(txSig);


time = 1:1:length(rxSig);
time = time * 1/nSamp;
% figure(1)
% subplot(211)
% plot(time,real(rxSig(1:end,1:N)))
% xlabel("time(s)")
% ylabel("Amplitude")
% title("Eye Diagram, In-Phase Component")
% 
% subplot(212)
% plot(time,imag(rxSig(1:end,1:N)))
% xlabel("time(s)")
% ylabel("Amplitude")
% title("Eye Diagram, Quadrature Component")

eyediagram(rxSig,nSamp);
