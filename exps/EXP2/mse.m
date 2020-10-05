
close all;
clear all;


f0 = 1000;


k = 5;
I = 2^k;

Ts = 1/f0;
Fs = 4000;



multiplier = 50;
t_analog = 0:0.000001:multiplier/f0;
x_analog = 5 + 5*cos(2*pi*f0*t_analog);

t_sampled = 0:1/Fs:multiplier/f0;
x_sampled = 5 + 5*cos(2*pi*f0*t_sampled);

%Plot original and sampled
%figure(1)
%plot(t_analog,x_analog),xlabel('time (s)'),ylim([-5 15]),xlim([0 multiplier/f0])
%hold on;
%stem(t_sampled,x_sampled,'r'),xlabel('time (s)'),ylim([-5 15]),xlim([0 0.01]),title("x(t) = 5 + 5cos(2 \pi f_{0} t), sampled at F_{s} = "+Fs)
%hold on;

del = (max(x_sampled)-min(x_sampled))/I;
ceiling = max(x_sampled) - del;
floor = min(x_sampled);

samples_count = length(x_sampled);
x_quantized = zeros(1,samples_count);

%Quantize
for sample_index = 1:1:samples_count
    
    if(x_sampled(sample_index) < floor)
       x_quantized(i) = floor;
    elif(x_sampled(sample_index)>celing-del)
      x_quantized(i) = ceiling;      
    else
    for i=floor:del:ceiling
        rangeLower = i;
        rangeUpper = i + del;
        if( x_sampled(sample_index) >= rangeLower && x_sampled(sample_index) <=rangeUpper)
           x_quantized(sample_index) = i;
        end
    end
    end
end
stem(t_sampled, x_quantized, 'm-'),title('Quantized samples')

%BPSK
bitLength = k;
bitStream = [];
for i= 1:1:samples_count
    if(x_quantized(i) == 0)
        bin = dec2bin(0,k);
    else
        bin = dec2bin(x_quantized(i)/del,k);
    end
    for j=1:1:k
        bitStream = [bitStream,str2num(bin(j))];
    end
end

%Modulate BPSK
for i = 1:1:length(bitStream)
    if(bitStream(i) == 0)
       bitStream(i) = -1; 
    end
end
%Add AWGN
SNR = 5; %Arbitrary
noisyStream = bitStream + 1/sqrt(2)*10^(-SNR/20) * randn(1,length(bitStream));

%Demodulation
demodStream = zeros(1,length(noisyStream));
for i = 1:1:length(noisyStream)
    if(noisyStream(i)>0)
        demodStream(i) = 1;
    else
        demodStream(i) = 0;
    end
end

%Convert back to symbols( Decode?)

%bitlength k
binSymbols = [];
for i = 1:k:length(demodStream)
    s = '';
    for j =1:1:k
       s = [s,int2str(demodStream(i+j-1))];
    end
    binSymbols = [binSymbols,convertCharsToStrings(s)];
end

decSymbols = zeros(1,length(binSymbols));
for i = 1:1:length(binSymbols)
    decSymbols(i) = bin2dec(binSymbols(i));
end

decSymbols = decSymbols .* del;

%mse

msep = sum((x_quantized-decSymbols).^2)/length(x_quantized)

stem(t_sampled,x_quantized)
hold on;
stem(t_sampled,decSymbols)
