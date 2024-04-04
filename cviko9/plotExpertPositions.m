function plotExpertPositions(sigInput, expert1Pos, expert2Pos, Fs, sigName, posName)

% Funkce pro vykresleni EEG a pozic K-komplexu dle vysledku vizualniho hodnoceni dvema lidskymi experty
% ***
% sigInput      - vstupni signal
% expert1Pos    - pozice K-komplexu dle 1. experta: 1. sloupec - zacatek, 2. sloupec - delka trvani (vse v sekundach)
% expert2Pos    - pozice K-komplexu dle 2. experta: 1. sloupec - zacatek, 2. sloupec - delka trvani (vse v sekundach)
% Fs            - vzorkovaci frekvence
% sigName       - nazev signalu, slouzi pouze pro zobrazeni v titulku


t = 0:1/Fs:length(sigInput)/Fs-1/Fs; % pro spravne zobrazeni casove osy v sekundach

sigMin = min(sigInput); % pro spravne zobrazeni pozic K-komplexu dle vizualniho hodnoceni expertu
sigMax = max(sigInput);

plot(t,sigInput, 'k')
title([sigName ' a ' posName])
xlabel('Cas, s')

hold on
line([expert1Pos(:,1)'; expert1Pos(:,1)'],[(ones(size(expert1Pos,1),1)*sigMin)';(ones(size(expert1Pos,1),1)*sigMax)'],'Color','g'); % zacatky K-komplexu dle hodnoceni 1. experta
line([(expert1Pos(:,1)+expert1Pos(:,2))'; (expert1Pos(:,1)+expert1Pos(:,2))'],[(ones(size(expert1Pos,1),1)*sigMin)';(ones(size(expert1Pos,1),1)*sigMax)'],'Color','g'); % konce K-komplexu dle hodnoceni 1. experta
line([expert2Pos(:,1)'; expert2Pos(:,1)'],[(ones(size(expert2Pos,1),1)*sigMin)';(ones(size(expert2Pos,1),1)*sigMax)'],'Color','b');% zacatky K-komplexu dle hodnoceni 2. experta
line([(expert2Pos(:,1)+expert2Pos(:,2))'; (expert2Pos(:,1)+expert2Pos(:,2))'],[(ones(size(expert2Pos,1),1)*sigMin)';(ones(size(expert2Pos,1),1)*sigMax)'],'Color','b');% konce K-komplexu dle hodnoceni 2. experta
hold off