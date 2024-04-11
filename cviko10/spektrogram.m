function SPEK = spektrogram(x, windowLength, overlap, Fs, indMarker, textSegment, textTime) 

%{
funkce pro VYPOCET a VYKRESLENI SPEKTROGRAMU bezneho signalu pomoci STFT.

Vstupni promenne:
  x             - vstupni signal
  windowLength  - delka okna (ve vzorcich)
  overlap       - prekryv okna (ve vzorcich)
  Fs            - vzorkovaci frekvence

Vystupni promenna:
  SPEK          - vzorky spektrogramu (v dB)
%}


L = length(x);  % delka vstupniho signalu
SPEK=[];        % alokace pameti pro spektrogram

for i=1:overlap:L-windowLength                                   % klouzave okno se zadanym prekryvem
    segment = x(i:i+windowLength-1)-mean(x(i:i+windowLength-1)); % vyber useku v okne
    window  = hamming(length(segment))';                         % okno pro vahovani
    segmentWeighted = window.*segment;                           % vahovany usek signalu
    spektrum=(abs(fft(segmentWeighted, Fs))).^2/length(segmentWeighted); % vykonove spektrum z useku
    logspektrum=20*log10(spektrum);                              % prevod do logaritmicke skaly (kvuli zobrazovani)
    SPEK=[SPEK logspektrum(1:end/2+1)'];                         % uloz pulku spektra do matice SPEK
end

band = 1:60;
SPEK = SPEK(band,:); % vyber jenom pasma 0-60 Hz pro zobrazeni (uzitecne pasmo EEG)

imagesc(linspace(0,L/Fs,size(SPEK,2)),...
         linspace(min(band),max(band),size(SPEK,1)),SPEK); % zobrazeni vybrane casti spektrogramu (2D mapa)

hold on    

indMarker = indMarker./Fs; % prepocet pozic markeru ze vzorku na sekundy
line([indMarker' indMarker'], [min(band) max(band)], 'Color', 'white', 'LineStyle' , '--','LineWidth',2)
for i = 1:size(textSegment,2)
    text(textTime(i),30, textSegment{i},'Color',[1 1 1],'FontSize',12)
end
hold off
c = colorbar('southoutside'); c.Label.String = 'Vykonove spektrum, dB';
xlabel('cas [s]');ylabel('frekvence [Hz]');
title('Spektrogram signalu (STFT)')