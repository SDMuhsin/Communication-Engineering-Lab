M = 16; % Modulation order
k = log2(M); % Bits/symbol
n = 20000; % Transmitted bits
nSamp = 4; % Samples per symbol
EbNo = 10; % Eb/No (dB)

span = 10; % Filter span in symbols
rolloff = 0.25; % Rolloff factor

x = randi([0 1],n,1);
txfilter = comm.RaisedCosineTransmitFilter('RolloffFactor',rolloff, 'FilterSpanInSymbols',span,'OutputSamplesPerSymbol',nSamp);
modSig = qammod(x,M,'InputType','bit');