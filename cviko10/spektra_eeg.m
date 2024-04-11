% -------------------------------------------------------------------------
% BPC-ABS cvièení -10-          2022-04-12                  Martin Vítek 
% Spektrální a èasovì-frekvenèní analýza EEG                Marina Ronzhina 
% -------------------------------------------------------------------------
% Tento skript slouží pro èasovou a spektrální analýzu EEG
% -------------------------------------------------------------------------
clear all
close all
clc

%% Cil 1: Seznameni se s vlastnostmi vykonoveho spektra EEG

%***** Nacteni a zobrazeni distupnych dat

load('eeg.mat') % 1svodove EEG 
load('markers.mat')  % pozice markeru pro vyznaceni jednotlivych useku EEG (dle protokolu mereni)
popisUsek = {'zavrene','otevrene+mrkani','zavrene', 'zavrene+zuby'}; % nazvy useku mereni (dle protokolu mereni)
popisCas = [30, 90, 140, 160]; % zacatky jednotlivych useku mereni (dle protokolu mereni)

Fvz = 250; % vzorkovaci frekvence snimani EEG

figure 
subplot(311)
plot_eeg(eeg, Fvz, indMarker, popisUsek, popisCas, 'Puvodni EEG')

%***** Vypocet spektra z jedne realizace signalu:

oknoDelka = Fvz*2; % nastaveni delky okna, tady delka okna = 2 sekundy
oknoHamming = hamming(oknoDelka)'; % vytvoreni Hammingova okna delkou oknoDelka

usek = eeg(1:oknoDelka); % vyber jedne realizace EEG
usek = usek - mean(usek); % odstraneni stejnosmerne slozky (SS)
usek = oknoHamming.*usek; % vahovani useku signalu Hammingovym oknem pro omezeni tzv. prosakovani spekter
oknoS = abs( fft( usek, oknoDelka ) ).^2/oknoDelka; % vypocet vykonoveho spektra z jedne realizace signalu

subplot(3,1,2);
fOsa = linspace(0,Fvz/2,length(oknoS)/2); % frekvencni osa pro spravne zobrazeni poloviny spektra
plot(fOsa, oknoS(1:end/2)); title('Periodogram z jedne realizace signalu'); % zobrazeni poloviny vykonoveho spektra
xlabel('Frekvence, Hz (pasmo 0-Fvz/2)')

%***** Odhad vykonoveho spektra metodou periodogramu s vyuzitim nekolika realizaci signalu:

[S, pocetUseku] = periodogramS(eeg, oknoDelka);

subplot(3,1,3);
plot( fOsa, S(1:end/2),'r'); % Zobrazeni poloviny vykonoveho spektra
title(['Vykonove spektrum signalu EEG z ' num2str(pocetUseku) ' realizaci'])
xlabel('Frekvence, Hz (pasmo 0-Fvz/2)')

%***** Vypocet relativnich vykonu v dilcich frekvencnich pasmech EEG:

P = specParamEEG(S, Fvz);

%% Cil 2: Sledovani vyvoje spektra EEG v case pomoci STFT: 

%***** Vypocet spektrogramu EEG:

prekryv = oknoDelka/2; % nastaveni prekryvu okna pro vypocet spektrogramu (tvori 50 % delky okna)

figure
subplot(3,1,1)
plot_eeg(eeg, Fvz, indMarker, popisUsek, popisCas, 'Puvodni EEG')
subplot(3,1,[2 3]); 
SP = spektrogram(eeg, oknoDelka, prekryv, Fvz, indMarker, popisUsek, popisCas); 

%***** Sledovani hodnot alfa rytmu v case:

[P, Pproc] = spectrogramParamEEG(SP, Fvz/oknoDelka);

vykonAlfa = P(3,:);
figure 
subplot(3,1,[1 2]); 
SP = spektrogram(eeg, oknoDelka, prekryv, Fvz, indMarker, popisUsek, popisCas); 
subplot(313)
plot(medfilt1(vykonAlfa,8)); xlim([0 length(vykonAlfa)])% medianova filtrace pro vyhlazeni prubehu
xlabel('Cas, s'), title('Prubeh vykonu v pasmu alfa')

%% Cil 3. Zpracovani EEG (eliminace artefaktu/sumu) a sledovani projevu ve spektru:

%***** Odstraneni driftu (kolisani nulove izolinie):

cutHigh = 1;
dHigh = designfilt('highpassiir','FilterOrder',4,'HalfPowerFrequency',cutHigh,'DesignMethod','butter','SampleRate',Fvz); % navrhni charakteristiku filtru
% freqz(dHigh)
% fvtool(dHigh)
eegHP = filtfilt(dHigh,eeg); % vyfiltruj puvodni EEG signal

[S, pocetUseku] = periodogramS(eegHP, oknoDelka); % vypocet vykonoveho spektra vyfiltrovaneho signalu
figure();
subplot(411)
plot_eeg(eegHP, Fvz, indMarker, popisUsek, popisCas, 'EEG po filtraci HP (cutoff = 1 Hz)')
subplot(412)
plot( fOsa, S(1:end/2),'r'); % Zobrazeni poloviny vykonoveho spektra
title('Vykonove spektrum')
xlabel('Frekvence, Hz (pasmo 0-Fvz/2)')
subplot(4,1,[3 4]); 
[SPEK] = spektrogram(eegHP, oknoDelka, prekryv, Fvz, indMarker, popisUsek, popisCas); % vypocet spektrogramu vyfiltrovaneho signalu


%***** Vyber frekvencniho pasma do 35 Hz (tj. odstraneni vsech slozek vyssich nez 35 Hz, vcetne sitoveho brumu):

cutLow = 35;
dLow = []; % navrhni charakteristiku filtru
% freqz(dLow)
% fvtool(dLow)
eegLP = []; % vyfiltruj eegHP tak, aby vysledny signal obsahoval slozky prevazne v pasmu (1-35 Hz)

[S, pocetUseku] = periodogramS(eegLP, oknoDelka); % vypocet vykonoveho spektra vyfiltrovaneho signalu

figure 
subplot(411)
plot_eeg(eegLP, Fvz, indMarker, popisUsek, popisCas, 'EEG po filtraci HP i LP (cutoff = 1 a 35 Hz)')
subplot(412)
plot( fOsa, S(1:end/2),'r'); % Zobrazeni poloviny vykonoveho spektra
title(['Výkonové spektrum signálu EEG z ' num2str(pocetUseku) ' realizaci'])
xlabel('Frekvence, Hz (pasmo 0-Fvz/2)')
subplot(4,1,[3 4]); 
[SPEK] = spektrogram(eegLP, oknoDelka, prekryv, Fvz, indMarker, popisUsek, popisCas); % vypocet spektrogramu vyfiltrovaneho signalu 


%***** Vypocet relativnich vykonu v dilcich frekvencnich pasmech filtrovaneho EEG:

P = specParamEEG(SPEK, Fvz);

%*****  Sledovani prubehu alfa rytmu v case po filtraci EEG:
[P, Pproc] = spectrogramParamEEG(SPEK, Fvz/oknoDelka);

vykonAlfa = P(3,:);
figure 
subplot(3,1,[1 2]); 
SP = spektrogram(eeg, oknoDelka, prekryv, Fvz, indMarker, popisUsek, popisCas); 
subplot(313)
plot(medfilt1(vykonAlfa,8)); xlim([0 length(vykonAlfa)])
xlabel('Cas, s'), title('Prubeh vykonu v pasmu alfa')