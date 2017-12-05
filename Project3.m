clear all;
clc;

% PART B(1)
% Read The Data Collected From Adams Car
[NUM, TXT, RAW] = xlsread('hardpoints team 14.xlsx', 'Part 1');
index = 1:101;

% Define Variables Obtained from Extraction
z = NUM(index, 1); % [mm] Wheel Vertical Displacement
z(61) = 0;
gamma = NUM(index, 2); % [deg] Camber Angle
alpha = NUM(index, 3); % [deg] Toe Angle
t0 = NUM(index, 5); % [mm] half track

gammaZero = gamma(61);
alphaZeroa = alpha(61);
t0Zero = t0(61);

% PART B(2): Plot The Extracted Data
figure; hold on;
subplot(2, 2, 1);
plot(z, gamma);
title('Camber Angle vs Wheel Travel');
xlabel('Wheel Travel [mm]');
ylabel('Camber [deg]');
grid on;

subplot(2, 2, 2);
plot(z, alpha);
title('Toe Angle vs Wheel Travel');
xlabel('Wheel Travel [mm]');
ylabel('Toe [deg]');
grid on;

subplot(2, 2, 3);
plot(z, t0);
title('Track vs Wheel Travel');
xlabel('Wheel Travel [mm]');
ylabel('Track [mm]');
grid on;

% EVALUATION OF STATIC FORCES ON SUSPENSION
ks = 24; % [N/mm]
Fs0 = 4195; % [N

% From Hardpoints Data
a = 621 - 391; % Spring Arm [mm]
b = 760 - 391; % Wheel Arm [mm]
ratio = a/b;
zitta = ratio*z;
zittaMax = max(zitta);
zittaMin = min(zitta);
zittaMean = (zittaMax + zittaMin)/2;
zittabLim = zittaMax - (zittaMax - zittaMean)/3;
zittarLim = zittaMin + (zittaMean - zittaMin)/3;

Fs = ks*zitta + Fs0;

Kb = ks*(zittaMax - zittaMean)/(zittaMax - zittabLim)^2;

for i = 1:17
   Fb1(i) = Kb*(zittarLim - zitta(i))^2;
   Ftot(i) = -Fb1(i) + Fs(i);
end

Ftot(18:84) = Fs(18:84);

for i = 85:101
   Fb2(i-84) = Kb*(zittabLim - zitta(i))^2; 
   Ftot(i) = Fb2(i-84) + Fs(i);
end

Fg = Ftot*ratio;
for i = 1:100
   Kg(i) = (Fg(i+1)-Fg(i))/(z(i+1)-z(i)); 
end

figure; hold on;
plot(z, Fg);
grid on;
title('Wheel-Ground Force vs Wheel Displacement');
xlabel('Wheel Displacement [mm]');
ylabel('Wheel-Ground Force [N]');

figure; hold on;
plot(z(1:100), Kg);
grid on;
title('Wheel-Ground Stiffness vs Wheel Displacement');
xlabel('Wheel Displacement [mm]');
ylabel('Wheel-Ground Stiffness Force [N]');