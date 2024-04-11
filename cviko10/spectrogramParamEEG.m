function [P, Pproc] = spectrogramParamEEG(SPEK, resolS)
%{
Funkce pro vypocet spektralnich parametru EEG v case
*******
S - vykonove spektrum EEG
resolS - krok (rozliseni) spektra: kolik herzu na spektralni caru
P - parametry vykonoveho spektra analyzovaneho EEG v case
Pproc - relativni parametry vykonoveho spektra analyzovaneho EEG v case
%}

borders = [0 4 8 13 30]/resolS; % hranice dilcich frekvencnich pasem EEG
borders(1) = borders(1)+1;      % vynechani stejnosmerne slozky 


for i = 1:4
    P(i,:) = sum(SPEK(borders(i)+1:borders(i+1),:)); % vypocitej vykon (jako soucet hodnot v ramci daneho pasma) v case
end

for i=1:4
    Pproc(i,:) = 100*P(i,:)./sum(P) % vypocitej relativni vykony pro dilci pasma (procentualni zastoupeni) v case
end



