function P = specParamEEG(S, fs)
%{
Funkce pro vypocet spektralnich parametru EEG
*******
S - vykonove spektrum EEG
fs - vzorkovaci frekvence EEG
P - parametry vykonoveho spektra analyzovaneho EEG:
    1. radek - hodnoty vykonu v jednotlivych pasmech EEG (delta az beta)
`   2. radek - relativni vykon EEG v jednotlivych pasmech (v %)
%}

resolS = fs/length(S);       % krok (rozliseni) spektra: kolik herzu na spektralni caru
borders = [0 4 8 13 30]/resolS; % hranice dilcich frekvencnich pasem EEG (prepocitane z Hz do vzorku) pro vyber pasem
borders(1) = borders(1)+1;      % vynechani stejnosmerne slozky (nezaciname od f = 0 Hz) 

for i = 1:4 % pro kazde pasmo 
    P(1,i) = 2*sum(S(borders(i)+1:borders(i+1))); % vypocitej vykon (jako soucet hodnot v ramci daneho pasma)
end
P_total = sum(P(1,:));
P(2,:) = 100*(P(1,:)/P_total); % vypocitej relativni vykony pro dilci pasma (procentualni zastoupeni)

disp('   delta      theta     alfa     beta')
disp(P(2,:))