clear all;

data = load("ACC.txt");
gm =  load("vzor_gravitace.txt");

ACCgm = sqrt(gm(:,2).^2 + gm(:,3).^2 + gm(:,4).^2);
ACCgm = mean(ACCgm);

t = data(:,1);
x = data(:,2);
y = data(:,3);
z = data(:,4);
ACCxyzg = sqrt(x.^2 + y.^2 + z.^2);
ACCxyz = ACCxyzg - ACCgm;

figure;
subplot(5,1,1)
plot(t,x);
xlabel('t')
ylabel('a [m/s^2]') 
title("ACCx");

subplot(5,1,2)
plot(t,y);
xlabel('t')
ylabel('a [m/s^2]') 
title("ACCy");

subplot(5,1,3)
plot(t,z);
xlabel('t')
ylabel('a [m/s^2]') 
title("ACCz");

subplot(5,1,4)
plot(t,ACCxyzg);
xlabel('t')
ylabel('a [m/s^2]') 
title("ACCxyzg");

subplot(5,1,5)
plot(t,ACCxyz);
xlabel('t')
ylabel('a [m/s^2]') 
title("ACCxyz");


chuze_data = load("vzor_chuze.txt");
ACCchuze = sqrt(chuze_data(:,2).^2 + chuze_data(:,3).^2 + chuze_data(:,4).^2);
ACCchuze = ACCchuze - ACCgm;
ACCchuzeM = mean(ACCchuze);

beh_data = load("vzor_beh.txt");
ACCbeh = sqrt(beh_data(:,2).^2 + beh_data(:,3).^2 + beh_data(:,4).^2);
ACCbeh = ACCbeh - ACCgm;
ACCbehM = mean(ACCbeh);

Nokno = ceil(length(ACCxyz)/40);
zaciatky_usekov = 1:40:length(ACCxyz);
konce_usekov = zaciatky_usekov+39;
UsekM = zeros(1,Nokno);
aktivita = zeros(length(ACCxyz),1);

for i = 1:Nokno
    UsekM(i) = mean(ACCxyz(zaciatky_usekov(i):konce_usekov(i)));
    if UsekM(i) >= ACCbehM/2 - 0.4
        aktivita(i*40 - 40 + 1:i*40) = 2;   
    elseif (UsekM(i) >= ACCchuzeM/2 - 0.2) && (UsekM(i) < ACCbehM/2 - 0.4)
        aktivita(i*40 - 40 + 1:i*40) = 1;  
    else 
        aktivita(i*40 - 40 + 1:i*40) = 0;
    end    
end 

figure;
plot(ACCxyz)
hold on
plot(aktivita)
title("Aktivita");
fvz = 20;

figure;
Wn = [1/fvz/2, 3.5/fvz/2];
[b,a] = fir1(100, Wn, "bandpass");
ACCxyz_filt = filter(b,a,ACCxyz);
plot(ACCxyz_filt);
steps = findpeaks(ACCxyz_filt,"Threshold",1);



