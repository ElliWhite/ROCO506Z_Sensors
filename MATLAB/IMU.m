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
title('Raw Angular Rotation');
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


%find average gradients    
Gradients = gradient(IntegratedGyroX); 
[sizeGrad,~] = size(Gradients);

avgGradientX = sum(Gradients)/sizeGrad;

FixedDataX = AnguRateX - Gradients;

FixedIntegratedGyroX = cumtrapz(FixedDataX);


figure;
hold on;
title('Angular Rotations With Correction');
xlabel('Time (Seconds)');
plot(TimeStamp, FixedIntegratedGyroX);
legend({'FixedIntegratedGyroX'}, 'Location', 'southwest');
hold off;
    

