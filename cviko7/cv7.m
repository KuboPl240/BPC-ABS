clear;
clc;
load('dower.mat')
I = inv(M'*M)*M';
O = load("MA1_117_03.mat");
S = load("MA1_117_12.mat");
signal = O;
O = O.x - mean(O.x,2);
S = S.x - mean(S.x,2);

Ot = I*S;

figure
for i = 1:3
    subplot(3,1,i)
    plot(O(i,:),'g')
    hold on
    plot(Ot(i,:),'m')
end    
legend('Original','Transformovaný');
signal = signal.x - mean(signal.x,2);

X = signal(1,:);
Y = signal(2,:);
Z = signal(3,:);

vectorECG = sqrt(X.^2 + Y.^2 + Z.^2);
[~,pos] = max(vectorECG);


figure;
subplot(2,2,1)
plot(Y, Z)
hold on
line([0 Y(pos)],[0 Z(pos)], 'Color', 'r')
subplot(2,2,2)
plot(Y, X);
hold on
line([0 Y(pos)],[0 X(pos)], 'Color', 'r')
subplot(2,2,3)
plot(X, Z);
hold on
line([0 X(pos)],[0 Z(pos)], 'Color', 'r')
subplot(2,2,4)
plot3(X, Y, Z);

fronDegree = atan(Z(pos)/Y(pos))*180/pi;


signal = load("MO1_117_03.mat");
signal = signal.x - mean(signal.x,2);

X = signal(1,:);
Y = signal(2,:);
Z = signal(3,:);

vectorECG = sqrt(X.^2 + Y.^2 + Z.^2);
[~,pos] = max(vectorECG);
[peak, locs] = findpeaks(vectorECG, "MinPeakHeight",400,"MinPeakDistance",200)

figure
plot(vectorECG);
figure
subplot(2,1,1)
for i = 1:length(locs)
    plot(Y,Z);
    xlabel("X")
    zlabel("Z")
    title("Frontálna")
    hold on
    line([0 Y(locs(i))], [0 Z(locs(i))], 'Color', 'red')
end

subplot(2,1,2)
for i = 1:length(locs)
    plot3(X,Y,Z);
    xlabel("X")
    ylabel("Y")
    zlabel("Z")
    title("3D VKG")
    hold on
    line([0 X(locs(i))], [0 Y(locs(i))], [0 Z(locs(i))], 'Color', 'red')
end

fronDegree = atan(Z(pos)/Y(pos))*180/pi;

