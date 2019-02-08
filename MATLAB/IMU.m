close all;

Data = readtable('testdata.txt');

TimeStamp = Data.Var1;
AccelX = Data.Var2;
AccelY = Data.Var3;
AccelZ = Data.Var4;
AnguRateX = Data.Var5;
AnguRateY = Data.Var6;
AnguRateZ = Data.Var7;
MagFieldX = Data.Var8;
MagFieldY = Data.Var9;
MagFieldZ = Data.Var10;

figure;
hold on;
title('Raw Acceleration');
xlabel('Time (Seconds)');
ylabel('G');
plot(TimeStamp, AccelX, TimeStamp, AccelY, TimeStamp, AccelZ);
legend({'AccelX','AccelY','AccelZ'}, 'Location', 'southwest');
hold off;

figure;
hold on;
title('Raw Angular Rotation (Static Gyro Readings)');
xlabel('Time (Seconds)');
ylabel('');
plot(TimeStamp, AnguRateX, TimeStamp, AnguRateY, TimeStamp, AnguRateZ);
legend({'AnguRateX','AnguRateY','AnguRateZ'}, 'Location', 'southwest');
hold off;

figure;
hold on;
title('Raw Magnetic Field');
xlabel('Time (Seconds)');
ylabel('');
plot(TimeStamp, MagFieldX, TimeStamp, MagFieldY, TimeStamp, MagFieldZ);
legend({'MagFieldX','MagFieldY','MagFieldZ'}, 'Location', 'southwest');
hold off;


%-----------------------¦
% GYRO DRIFT CORRECTION ¦
%-----------------------¦

%----------------------------------------------¦
% Take integral of gyro readings to get angles ¦
%----------------------------------------------¦
IntegratedGyroX = cumtrapz(AnguRateX);
IntegratedGyroY = cumtrapz(AnguRateY);
IntegratedGyroZ = cumtrapz(AnguRateZ);

figure;
hold on;
title('Integrated Angular Rotations (Gyro Drift)');
xlabel('Time (Seconds)');
plot(TimeStamp, IntegratedGyroX, TimeStamp, IntegratedGyroY, TimeStamp, IntegratedGyroZ);
legend({'IntegratedGyroX','IntegratedGyroY','IntegratedGyroZ'}, 'Location', 'southwest');
hold off;

% AnguRate here is the original testing data. Will need to change this new
% data to really test drift
CorrectedGyroDataX = cumtrapz(AnguRateX) - IntegratedGyroX;
CorrectedGyroDataY = cumtrapz(AnguRateY) - IntegratedGyroY;
CorrectedGyroDataZ = cumtrapz(AnguRateZ) - IntegratedGyroZ;

figure;
hold on;
title('Angular Rotations With Correction');
xlabel('Time (Seconds)');
plot(TimeStamp, CorrectedGyroDataX, TimeStamp, CorrectedGyroDataY, TimeStamp, CorrectedGyroDataZ);
legend({'FixedGyroDataX', 'FixedGyroDataY', 'FixedGyroDataZ'}, 'Location', 'southwest');
hold off;


%---------------------------------¦
% ACCELEROMETER JITTER CORRECTION ¦
%---------------------------------¦
AccelXFFT = fft(AccelX);
Fs = 83.3333;            % Sampling frequency 

% % compute the two-sided spectrum P2
% L = 447816.01;              % Length of signal (ms)
% P2 = abs(AccelXFFT/L);
% 
% % compute the single-sided spectrum P1 based on P2 and the even-valued
% % signal length L
% P1 = P2(1:18613+1);
% P1(2:end-1) = 2*P1(2:end-1);
% 
% % define the frequency domain f and plot the single-sided amplitude spectrum P1
% 
% f = Fs*(0:18613)/L;
% figure;
% plot(f,P1) 
% title('Single-Sided Amplitude Spectrum of X(t)')
% xlabel('f (Hz)')
% ylabel('|P1(f)|')
% 
% AccelXFFT_mag = abs(AccelXFFT);
% %%Frequency bins
% N = length(AccelXFFT);
% Fbins = ((0: 1/N: 1-1/N)*Fs).';
% figure;
% plot(Fbins, AccelXFFT_mag);
% box on;
% grid on;



L=length(AccelX);        
X=fft(AccelX,L);       
Px=X.*conj(X)/(L*L); %Power of each freq components       
fVals=Fs*(0:L/2-1)/L;      
figure;
plot(fVals,Px(1:int16(L/2)-1),'b','LineWidth',1);   
grid on;
title('One-Sided Power Spectral Density');       
xlabel('Frequency (Hz)')         
ylabel('PSD');

    

