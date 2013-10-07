%%Double-Notch Filter

clear all;
clc;
close all;

%% load audio signal
load x;

%% two undesired frequencies
f1 = 697; %Hz
f2 = 1209; %Hz
T = 1/8192;
Fs = 1/T;

%% calculate radian frequencies
w1 = 2*pi*f1*T;
w2 = 2*pi*f2*T;

%% Selection of Pole Zero locations

%want to place zeros directly on these frequencies, poles very close to
%them, so as to level out the frequency response not in bandstop regions
z1 = 1*exp(j*w1); z2 = 1*exp(-j*w1);
z3 = 1*exp(j*w2); z4 = 1*exp(-j*w2);

p1 = .99*exp(j*w1); p2 = .99*exp(-j*w1);
p3 = .99*exp(j*w2); p4 = .99*exp(-j*w2);

%copy into vector form for easy functions calling
zvec = [z1;z2;z3;z4];
pvec = [p1;p2;p3;p4];

%Plot our system in the z-plane
zplane(zvec,pvec);
title('Pole-Zero Map of Filter');

%% generate Z-Transform
a = poly(pvec);
b = poly(zvec);

%Find gain
G = polyval(a,1) / polyval(b,1);
b = b*G;

%% generate output
out = filter(b,a,x);

%% Plot Frequency Response
figure();
[H,w] = freqz(b,a,Fs);
plot(w,abs(H));
xlabel('Freqency (rads/sec)');
ylabel('|H(\omega)|');
title('Frequency Response of Double Notch Filter');

%% Get symbolic representation of H(z)
%H = zpk(zvec,pvec,G,Fs);


