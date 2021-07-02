function [sPlot] = CreatePlotConfig(isPlot, stftNumSamplesInFrame, stftNumSamplesNonOverlap, stftNumFreqBins)
% Synopsis : This function creates a configuration struct for plotting
% Written by Yair Yarden and Ofir Kedem - 2021
% ----------------------------------------------------------------
sPlot.isPlot = isPlot;
sPlot.stftNumSamplesInFrame = stftNumSamplesInFrame;
sPlot.stftNumSamplesNonOverlap = stftNumSamplesNonOverlap;
sPlot.stftNumFreqBins = stftNumFreqBins;

end

