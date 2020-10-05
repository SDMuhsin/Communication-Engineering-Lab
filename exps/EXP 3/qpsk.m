clear all;
close all;

N = 512; %Number of symbols
f = 1000; %carrier frequency

x = randi([0 1],[1 2*N]); % Since two bits per symbols
x_nrz = 2*x - 1;

x_even = x_nrz(2:2:length(x));
x_odd = x_nrz(1:2:length(x));

%Modulate onto carrier
symbol_rate = 250;
T = 1/symbol_rate; % Symbol Duration
time_precision = T/100;
t = 0:time_precision:T;

x_modulated = [];
x_inphase = [];
x_quadrature = [];
for i = 1:1:length(x_even)
    x_inphase = [x_inphase,x_odd(i)*cos(2*pi*f*t)];
    x_quadrature = [x_quadrature,x_even(i)*sin(2*pi*f*t)];
    
end
x_modulated = x_inphase + x_quadrature;

t_full = 0:1:length(x_modulated)-1;
t_full = t_full.*time_precision;

figure(1)
subplot(311)
plot(t_full,x_quadrature);
subplot(312)
plot(t_full,x_inphase);
subplot(313)
plot(t_full,x_modulated);

figure(2)
%Generating Constellation
x_constellation = x_odd + j.*x_even;
scatter(real(x_constellation),imag(x_constellation),'filled','linewidth',3)
axis([-2 2 -2 2])
xlabel('In Phase Component')
ylabel('Quadrature Component')
title('QPSK constellation')
grid on;

SNR = 10;
figure(3)
x_noisy_symbols = x_constellation + (1/sqrt(2))*(1/sqrt(2)*10^(-SNR/20)) * randn(1,length(x_constellation)) + 1i * (1/sqrt(2))*(1/sqrt(2)*10^(-SNR/20)) * randn(1,length(x_constellation));
scatter(real(x_noisy_symbols),imag(x_noisy_symbols),'filled','linewidth',0.5)
axis([-2 2 -2 2])
xlabel('In Phase Component')
ylabel('Quadrature Component')
title("QPSK constellation with AWGN, SNR = "+ SNR)
grid on;

%Pulse shaping

 roll_off = 0.35;
 span = 10;
 sps = 8*symbol_rate;
% h = rcosdesign( roll_off ,span, symbol_rate*8);
% 
% x_shaped = upfirdn( x_modulated, h, symbol_rate*8);

h = rcosdesign( roll_off, span, sps);
x_pulsed = upfirdn( x_nrz, h, sps);

