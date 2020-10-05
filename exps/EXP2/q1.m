close all;
clear all;


f0 = 1000;
Fs = 10000;

k = 2;
I = 2^k;

multiplier = 30;
t_analog = 0:0.0001:multiplier/f0;
x_analog = 5 + 5*cos(2*pi*f0*t_analog);

t_sampled = 0:1/Fs:30/f0;
x_sampled = 5 + 5*cos(2*pi*f0*t_sampled);

%Plot original and sampled
figure(1)
plot(t_analog,x_analog),xlabel('time (s)'),ylim([-5 15]),xlim([0 multiplier/f0])
hold on;
stem(t_sampled,x_sampled,'r'),xlabel('time (s)'),ylim([-5 15]),xlim([0 0.01]),title("x(t) = 5 + 5cos(2 \pi f_{0} t), sampled at F_{s} = "+Fs)
hold on;

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
           x_quantized(sample_index) = i+del/2;
        end
    end
    end
end
hold off;
figure(2)
stem(t_sampled, x_quantized, 'm-'),title('Quantized samples')

