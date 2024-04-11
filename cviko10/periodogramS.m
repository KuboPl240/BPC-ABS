function [S, segmentNumb] = periodogramS(inputSig, windowLength)

%{
Funkce pro odhad vykonoveho spektra signalu metodou periodogramu
*** 
inputSig - analyzovany signal
windowLength - delka okna pro vypocet spektra
S - vysledny odhad vykonoveho spektra
segmentNumb - pocet realizaci signalu pouzitych pro vypocet spektra
%}
inputLength = length(inputSig);         % delka vstupniho signalu
S = zeros(1,windowLength);              % promenna (vektor-radek) pro ukladani vykonovych spekter
windowHamming = hamming(windowLength)'; % okno pro omezeni tzv. prosakovani ve spektru
segmentNumb = 0;                        % pocet useku (realizaci) signalu

% Postupne prochazime signal po blocich a z nich pocitame vykonove spektrum a
% prumerujeme je:
for i=1:windowLength:inputLength-windowLength 
    segment = inputSig(i:i+windowLength-1);     % vybereme usek signalu 
    segment = segment - mean(segment);     % omezime stejnosmernou slozku odectenim stredni hodnoty
    segment = windowHamming.*segment;     % vahujeme usek oknem pro omezeni prosakovani spekter
    f = abs(fft(segment,windowLength)).^2;           % vypocitame vykonove spektrum z daneho useku
    S = S + (f/windowLength);       % akumulujeme spektra vypocitana z dilcich useku signalu
    segmentNumb = segmentNumb + 1;  % aktualizujeme promennou segmentNumb
end
S = S/segmentNumb; % podelime soucet vsech spekter poctem realizaci, pro dokonceni prumerovani
