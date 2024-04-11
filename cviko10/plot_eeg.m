function plot_eeg(x, Fs, indMarker, textSegment, textTime, textTitle)

%{ 
Funkce pro vykresleni EEG a vyznaceni jednotlivych useku signalu.

Vstupni promenne:
* x - vstupni signal
* Fs - vzorkovaci frekvence 
* indMarker - pozice markeru (ve vzorcich)
* textSegment - popisek useku EEG
* textTime - pozice popisku v ramci celeho signalu (v sekundach)
* textTitle - nazev grafu (pro vypis prikazem 'title')
%}

t = 0:1/Fs:length(x)/Fs - 1/Fs;   % casova osa v sekundach
indMarker = indMarker./Fs; % prevod pozic markeru ze vzorku na sekundy


plot(t, x, 'k'); xlabel('Cas, s'); ylabel('U, \muV'); 
hold on
line([indMarker' indMarker'], [min(x) max(x)], 'Color', 'black', 'LineStyle' , '--'); 
for i = 1:size(textSegment,2)
    text(textTime(i),max(x), textSegment{i},'FontSize',12)
end
xlim([0 length(x)/Fs-1/Fs])
ylim([min(x) max(x)+0.3*max(x)])
title(textTitle)