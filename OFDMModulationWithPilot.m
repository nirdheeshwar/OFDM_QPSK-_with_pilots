function [ TimeDomainValues,LocationOfDataCarriers  ,PilotLocations] = OFDMModulationWithPilot( FFTCoeff, FFTSize, DataCarriersCount , PilotSymbol)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
j = 2;
Pcount = 1;
InputSequenceP = zeros(1,FFTSize/2);
InputSequenceN = zeros(1,FFTSize/2);
for(idx=1:FFTSize/2)
    if(rem(idx-1,9) == 0)
       InputSequenceP(idx) = PilotSymbol(Pcount);
       Pcount = Pcount +1;
    else
        InputSequenceP(idx) = FFTCoeff(j-1);
        j=j+1;
        if(j>(DataCarriersCount/2)+1)
               break;
        end;
    end
end

j=1;        
for(idx=1:FFTSize/2)
    if(rem(idx-1,9) == 0)
       InputSequenceN(idx) = PilotSymbol(Pcount);
       Pcount = Pcount + 1;
    else
    InputSequenceN(idx) = FFTCoeff(j+(DataCarriersCount/2));
    j=j+1;
    if(j>(DataCarriersCount/2))
          break;
    end
    end
end
%% Frequency Domain values of QFDM Signal %%
FFTCoeffLoaded = [ InputSequenceP flip(InputSequenceN)];
FFTCoeffLoaded(FFTSize/2) = PilotSymbol(Pcount);
LocationOfDataCarriers = find((abs(FFTCoeffLoaded) ~= 2*sqrt(2)) & (FFTCoeffLoaded ~= 0));
PilotLocations = find(abs(FFTCoeffLoaded) == 2*sqrt(2) );
VirtualCarriers = find(FFTCoeffLoaded == 0);
%% Time domain Signal of QFDM Signal      %%
TimeDomainValues = ifft(FFTCoeffLoaded)*sqrt(FFTSize);


end

