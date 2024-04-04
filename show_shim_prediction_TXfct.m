function  fighandle = show_shim_prediction_TXfct(shimset, b1p, roi, varargin)
 %% ************************************************************************
%
%   Plots the shim prediction based on the shimset (can be phase and
%   magnitude)
%   
%   Author: S.Schmitter
%   Date: Jan 2016
%
%
%   dependencies:
%   - multiprod
%   - parseVariableInputs
%   - catstruct
%
%   INPUT:                                                  [unit]
%   ----------------------------------------------------------------
%   shimset     coplex vector of phase shim values 
%   b1p         b1+ maps
%   roi         region of interest
%
%   Options (with standard prefs)                           [unit]
%   ----------------------------------------------------------------
%                          
%
%   OUTPUT:
%   ----------------------------------------------------------------
%   ValueStruct     Struct containing the quantified values 
%
%% ************************************************************************

    optsdef.TEST = 0;
    optsdef.SAVEMAPS = 0;
    optsdef.ROTATE = 0;
    optsdef.COLORMAP = 'thermal'; %uses the cmocean colormaps
    optsdef.COLORMAPEFF = 'solar';

    opts    = catstruct(optsdef,parseVariableInputs(varargin));

    shimvec = makeColVec(shimset);
    
    b1pat_post = abs(multiprod(b1p,shimvec,4,1));
    b1pat_pre = abs(multiprod(b1p,ones(size(shimvec)),4,1));
    b1pat_both = cat(3,b1pat_pre,b1pat_post);
       
    b1sumofmag = multiprod(abs(b1p),abs(shimvec),4,1);
    
    Eff_pre = abs(b1pat_pre)./b1sumofmag;
    Eff_post = abs(b1pat_post)./b1sumofmag;
    Eff_both = cat(3,Eff_pre,Eff_post);
    %plot the prediction before and after shimming
    
    roi_bot = cat(3,roi,roi);
    
    tmp_pre = abs(b1pat_pre(~~roi));
    tmp_post = abs(b1pat_post(~~roi));
     
    CV_pre = std(tmp_pre(:))/mean(tmp_pre(:));
    CV_post = std(tmp_post(:))/mean(tmp_post(:));
    
    MeanEff_pre = mean(Eff_pre(~~roi));
    MeanEff_post = mean(Eff_post(~~roi));
    
    
    lNoOfSlices = size(b1p,3);
    
    %added 20181130: handle rotation
    if(opts.ROTATE == 270)
        b1pat_both=rot270(b1pat_both);
        roi_bot=rot270(roi_bot);
        Eff_both = rot270(Eff_both);
    end
    if(opts.ROTATE == 180)
        b1pat_both=rot180(b1pat_both);
        roi_bot=rot180(roi_bot);
        Eff_both = rot180(Eff_both);
     end
    if(opts.ROTATE == 90)
        b1pat_both=rot90m(b1pat_both);
        roi_bot=rot90m(roi_bot);
        Eff_both = rot90(Eff_both);
    end
    
    
    %show the b1 prediction
    propout = show3dWithMaskm((b1pat_both),(roi_bot),2,lNoOfSlices);
    cc = colorbar();
    cc.Label.String = 'B1+ in a.u.';
    colormap(cmocean(optsdef.COLORMAP));
    %caxis([0 90]);
%     axis off;
    axis image; %enforce equal image aspect ratio

    title({'B1+ prediction';...
        ['Before shim (first row): CV = ', num2str(CV_pre*100,'%.1f'),'%  Mean efficiency: ', num2str(MeanEff_pre*100,'%.1f'),'%  Min. B1+: ', num2str(min(tmp_pre(:)),'%.1f')];...
        ['After shim (second row): CV = ', num2str(CV_post*100,'%.1f'),'%  Mean efficiency: ', num2str(MeanEff_post*100,'%.1f'),'%  Min. B1+: ', num2str(min(tmp_post(:)),'%.1f')]});
        
%           ['Before shim (first row): CV = ', num2str(CV_pre*100,'%.1f'),'%     Mean efficiency: ', num2str(MeanEff_pre*100,'%.1f'),'%'];...
%           ['After shim (second row): CV = ', num2str(CV_post*100,'%.1f'),'%     Mean efficiency: ', num2str(MeanEff_post*100,'%.1f'),'%']});
   
    propout2 = show3dWithMaskm((Eff_both),(roi_bot),2,lNoOfSlices);
    cc = colorbar();
    cc.Label.String = 'Efficiency';
    colormap(jet);%cmocean(optsdef.COLORMAPEFF));
%     colormap(cmocean(optsdef.COLORMAP));
    
    caxis([0 1]);
%    axis off;
    axis image; %enforce equal image aspect ratio

    title({'RF efficiency';...
          ['Before shim (first row): CV = ', num2str(CV_pre*100,'%.1f'),'%  Mean efficiency: ', num2str(MeanEff_pre*100,'%.1f'),'%  Min. B1+: ', num2str(min(tmp_pre(:)),'%.1f')];...
          ['After shim (second row): CV = ', num2str(CV_post*100,'%.1f'),'%  Mean efficiency: ', num2str(MeanEff_post*100,'%.1f'),'%  Min. B1+: ', num2str(min(tmp_post(:)),'%.1f')]});
   
    fighandle(1) = propout.fighandle;
    fighandle(2) = propout2.fighandle;
    
end