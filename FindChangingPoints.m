function [changingPoints] = FindChangingPoints(instFreqVec, changeTh)
% Synopsis : 
% INPUTS : 
% OUTPUTS : 
% Written by Yair Yarden and Ofir Kedem - 2021
% ---------------------------------------------------------------
numPoints = length(instFreqVec);
currFreqVec = instFreqVec(1);
changingPoints = 1;
for iPoint = 2 : numPoints
    diffVec = abs(instFreqVec(iPoint) - currFreqVec);
    maxDiff = max(diffVec);
    if(maxDiff > changeTh)
        changingPoints = [changingPoints, iPoint];
        currFreqVec = instFreqVec(iPoint);
    else
        currFreqVec = [currFreqVec, instFreqVec(iPoint)];
    end
end


end

