function [betaAll,fAll] = b1_phase_shimming_TXfct(b1p,roi,varargin)

%% ************************************************************************
%
% This is the optimization routine for predistorted B1shim. It uses a
% constraint nonliniear optimization algorithm to vary the phases (only) in
% order to match b1 plus with the target. 
% 
%
%   INPUT:                                                  [unit]
%   ----------------------------------------------------------------
%   b1plusmph:  complex 4D data with b1 plus profiles 
%   dMask:      contains the mask for the optimization ROI. The dimension 
%               of the mask must be 3d with same size as dTarget as well as
%               the size of the first 3 dim of b1plusmph
%   dTarget:    contains the target in a.u.
%
%
%   OUTPUT:
%   ----------------------------------------------------------------
%   xhat:       complex vector with phase setting of the cannels
%
%% ************************************************************************

optsdef.WHICHCHANNELS = (1:size(b1p,4)).';
optsdef.MASKSTAYSAME = [];
optsdef.MEANPOWER = 1;
optsdef.SUMUPTOTHATTHRESHOLD = 0.1;  


optargin = size(varargin,2);
opts    = catstruct(optsdef,parseVariableInputs(varargin));
opts.CHANNELVEC = [opts.WHICHCHANNELS; opts.WHICHCHANNELS];

%shim vector (starting value
Beta0 = opts.BETA0;

b1p	= double(b1p);       
b1p(~isfinite(b1p))     = 0;    %erases inf. values

scfact      = 1;%scaling factor, optional

b1psize     = size(b1p);
sz = b1psize;
lNoOfCha	= b1psize(4);

b1plustmp	= reshape(b1p,[prod(sz(1:3)),sz(4)]);
Atmp        = b1plustmp(find(roi),:); %optimize only those values withinn mask
                                            %creates Nx16 matrix (for 16
                                            %channels)
Ttmp        = roi(find(roi));     %shrink the target to 1D array
%find nonzero values, i.e. those for A*ones(16,1) != 0
lNonZeroInd = find(Atmp*ones(lNoOfCha,1));
A           = scfact*Atmp(lNonZeroInd,:);
T           = Ttmp(lNonZeroInd);

% mod ss: if the overall pattern should not change:
B           = b1p(find(opts.MASKSTAYSAME),:);
opt.B      = B;

opts.LASTLOWINDEX = ceil(opts.SUMUPTOTHATTHRESHOLD.*size(A,1));

betaAll = zeros(sz(4), opts.NOOFSTARTPHASES);
fAll    = zeros(opts.NOOFSTARTPHASES,1);

%run loop over different starting values:
for lL = 1:opts.NOOFSTARTPHASES
    
    cxBeta0 = makeColVec(opts.BETA0(lL,1:sz(4)));
    dBeta0         = [real(cxBeta0); imag(cxBeta0)]; %only real values, but 2*lNoOfCha


    %call of kernel (fmincon routine):
    [x,fval,exitflag,output] = runOptimization(A,dBeta0,T,opts);

    betaAll(:,lL)       = makeColVec(x(1:end/2)+1i*x(end/2+1:end)); 
    fAll(lL,1)      	= fval;
end
end



%% *************************************************************************
% local Functions:
%%*************************************************************************
function [x,fval,exitflag,output] = runOptimization(A,dX0,dTVec,prop)

    %options:
    options = optimset('Algorithm','interior-point');
    options.MaxIter         = 3e3;
    options.LargeScale      = 'on';
    options.MaxFunEvals     = 1e5;
    options.TolX            = 1e-12;
    options.TolCon          = 1e-12;
    options.TolFun          = 1e-12;
    
    meanpower = prop.MEANPOWER;
    
    lChaVec = prop.CHANNELVEC;
    
    [x,fval,exitflag,output]  = fmincon(@(x)objfunEffHomHybrid(x,A,dTVec,meanpower,prop.LAMBDA),...
                                        dX0,...
                                        [],[],[],[],[],[],...
                                        @confun,...
                                        options);
    
end

%objective function
function f = objfunEffHomHybrid(xx,A,dTVec,meanpower,dLambda)
    x = makeColVec(xx(1:end/2)+1i*xx(end/2+1:end));
    atmp        = abs(A*x);
    feff        = mean(abs(A*x)./(abs(A)*abs(x)));
    meana       = mean(atmp);
    meant       = mean(dTVec);
    stda        = std(atmp-dTVec/meant*meana);
    fhom        = stda/(meana)^meanpower;   

    f           = (1-dLambda)*fhom*fhom+dLambda*1/feff/feff;
end


% function for constraints 
function [cineq, ceq] = confun(xx)
    x       = xx(1:end/2)+1i*xx(end/2+1:end); 
    ceq     = [abs(x)-1];
    cineq   = [];
end