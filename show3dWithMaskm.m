function propout = show3dWithMaskm(in3DArray,inMask,lNoOfWndsY,lNoOfWndsX,varargin)
%%**********************************************************************
%
%   plots all Slices of a 3D or 4D matrix. The ordering must be the
%   following:
%   1+2. dimension:     Image 
%   3. dimension:       Slices
%   4. dimension:       Channels (optional)
%
%
%   INPUT:                                                  [unit]
%   ----------------------------------------------------------------
%   in4DArray:          multislice (+multichannel) data
%
%   OUTPUT:
%   ----------------------------------------------------------------
%   handle:             function returns the handle of the new figure
%
%
%   OPTIONAL:
%   ----------------------------------------------------------------
%   PLOTSUBFIGS:        plots a subfigure 
%
%%**********************************************************************

optargin = size(varargin,2);

propdef    = struct;
propdef.LINECOLOR   = 'white';
propdef.PLOTSUBFIGS = false;
propdef.NEWFIG      = true;

lSize       = size(in3DArray);
if(length(lSize)>2)
    lScaleHorz  = 2;%ceil(sqrt(lSize(3)));
%     lScaleHorz  = floor(sqrt(lSize(3)));
    lScaleVert  = 3;%ceil(lSize(3)/lScaleHorz);
else
    lScaleHorz  = 1;
    lScaleVert  = 1;
    lSize(3) = 1;
end

propdef.SCALEHORZ         = lNoOfWndsX;
propdef.SCALEVERT         = lNoOfWndsY;


prop    = catstruct(propdef,parseVariableInputs(varargin));
propout = prop;

% dIma2D = conv3Dto2DImage(in3DArray,prop); %SeSc
dIma2D = montager(in3DArray, 'col',3,'row', 2);
% dMask2D = conv3Dto2DImage(inMask,prop); %SeSc
dMask2D = montager(inMask, 'col',3,'row', 2);

dImaMax = max(dIma2D(:));
if(dImaMax == 0) 
    dImaMax = 1;
end

if(prop.NEWFIG)
    propout.fighandle = figure;
else
   propout.fighandle = gcf; 
end
hold on;
propout.imagehandle = imagesc(dIma2D);
myaxis   = gca;
if(isfield(prop,'CAXIS'))
   caxis(prop.CAXIS);
else
   caxis auto;
end
set(gca,'YDir','reverse');
axis off;
propout.contourhandle = contour(myaxis,dMask2D./double(max(dMask2D(:))).*dImaMax,1,'LineColor',prop.LINECOLOR);
axis off;
hold off
    


end