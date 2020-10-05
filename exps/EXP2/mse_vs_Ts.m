
close all;
clear all;

f0 = 10000;

ks = [2 3 4 5 ];
Fss = [ 10*f0 20*f0 30*f0 40*f0 50*f0];

msep = [];
for k = ks
msep = [];
for Fs = Fss
I = 2^k;

multiplier = 30;
t_analog = 0:0.000001:multiplier/f0;
x_analog = 5 + 5*cos(2*pi*f0*t_analog);

t_sampled = 0:1/Fs:multiplier/f0;
x_sampled = 5 + 5*cos(2*pi*f0*t_sampled);

%Plot original and sampled
%figure()
%plot(t_analog,x_analog),xlabel('time (s)'),ylim([-5 15])
%hold on;
%stem(t_sampled,x_sampled,'r'),xlabel('time (s)'),ylim([-5 15]),xlim([0 0.01]),title("x(t) = 5 + 5cos(2 \pi f_{0} t), sampled at F_{s} = "+Fs)


del = (max(x_sampled)-min(x_sampled))/I;
ceiling = max(x_sampled) - del;
floor = min(x_sampled);

samples_count = length(x_sampled);
x_quantized = zeros(1,samples_count);

%Quantize

% for sample_index = 1:1:samples_count
%     
%     if(x_sampled(sample_index) < floor)
%        x_quantized(i) = floor;
%     elif(x_sampled(sample_index)>celing-del)
%       x_quantized(i) = ceiling;      
%     else
%     for i=floor:del:ceiling
%         rangeLower = i;
%         rangeUpper = i + del;
%         if( x_sampled(sample_index) >= rangeLower && x_sampled(sample_index) <=rangeUpper)
%            x_quantized(sample_index) = i;
%         end
%     end
%     end
% end 

for i = 1:1:length(x_sampled)
    x_quantized(i) = myQuantize(x_sampled(i),del);
end
%stem(t_sampled, x_quantized, 'm-'),title('Quantized samples')

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
SNR = 1; %Arbitrary
noisyStream = bitStream + 1/sqrt(2)*10^(-SNR/20) * randn(1,length(bitStream));

%Demodulation
demodStream = zeros(1,length(noisyStream));
for i = 1:1:length(noisyStream)
    if(noisyStream(i)>=0)
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

%decSymbols = decSymbols .* del;
for i = 1:1:length(decSymbols)
    decSymbols(i) = requant(decSymbols(i),del);
end
%mse

msep = [msep,(sum((x_quantized-decSymbols).^2)/length(x_quantized)*k^2 + k^2)/k];
end
%plot MSE vs
plot(Fss,msep),xlabel("F_{s} (Hz)"),ylabel("MSE"),title("MSE vs F_{s} for various I"),legend([ "I = 4" "I = 8" "I = 16" "I = 32"]);
hold on;
end

