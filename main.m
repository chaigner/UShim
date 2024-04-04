% This script loads channel-wise in vivo B1+ datasets of the human cervical 
% and thoracolumbar spine at 7T and to compute and evaluate universal 
% RF shims as described in: 
% 
% Aigner, Sanchez Alarcon, D'Astous, Alonso-Ortiz, Cohen-Adad and 
% Schmitter. Calibration-Free Parallel Transmission of the Cervical, 
% Thoracic, and Lumbar Spinal Cord at 7T. Submitted to MRM 
%
% The channel-wise in vivo B1+ datasets of the human body at 7T are 
% available at: https://doi.org/10.6084/m9.figshare.14778345.v2 .
%
% Created by Christoph S. Aigner, PTB, February 2024.
% Email: christoph.aigner@ptb.de
%
% This code is free under the terms of the GPL-3.0 license.

%load the CSPINE data
load('data/CSpine_data.mat'); 

%load the TLSPINE data
% load('TLSpine_data.mat');

%load the phase init
load('data/Matlab_WS_Startphases_cxX0_1000x64.mat');

%params
optsdef.BETA0           = cxX0; %starting phase
optsdef.NOOFSTARTPHASES = 8;    %compute 8 solutions with different init
optsdef.LAMBDA          = 0.05; %cost homogeneity-efficiency weighting 
numb_subjects = size(ROI.masks,3);

%compute universal RF shims with different phase inits
[betaAll,fAll]     = b1_phase_shimming_TXfct(B1p.cxmap,ROI.masks,optsdef);

%now determin the best solution
[mmin, mind]    = min(fAll); 
lSolution       = mind;

%calculate values for best solution
Shim.CurSet = betaAll(:,lSolution);
Shim.Values = quantify_phase_shim_TXfct(Shim.CurSet,B1p.cxmap,ROI.masks);

mtmp = abs(multiprod(B1p.cxmap,makeColVec(Shim.CurSet),4,1));
Shim.B1pred_mag = abs(mtmp);
Shim.B1pred_pha = angle(mtmp);

%calculate values for all solutions:
ShimStr.BestShim = Shim.CurSet;
ShimStr.AllShims = betaAll;
ShimStr.NoOfStartingPhases = optsdef.NOOFSTARTPHASES;

ShimStr.Values = Shim.Values;
for lL=1:optsdef.NOOFSTARTPHASES
    ShimStr.ValuesAll(lL) = quantify_phase_shim_TXfct(betaAll(:,lL),B1p.cxmap,ROI.masks);
end

%Plot the Results
optsdef.ROTATE = 180;
show_shim_prediction_TXfct(Shim.CurSet, B1p.cxmap, ROI.masks, optsdef);
