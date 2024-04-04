function dRotImage = rot180(dimage)


%%**********************************************************************
%
%   function dRotImage = rot270(dimage)
%   
%   rotates a matrix by 90 deg. matrix dimage can have up to 4 dimension,
%   however dimension 1 and 2 will be rotated
%
%   INPUT:                                                          [unit]
%   -----------------------------------------------------------------------
%   dimage          Image or matrix (up to 4D)
%
%   OUTPUT:
%   -----------------------------------------------------------------------
%   dRotImage       rotated image or matrix
%           
%%**********************************************************************

    ds = size(dimage);
    
    if(length(ds) == 2)
        dRotImage = (rot90(rot90(dimage)));
    end
    if(length(ds) > 2)
       for lS = 1:ds(3) 
            for lM = 1:size(dimage,4)
                dRotImage(:,:,lS,lM) = (rot90(rot90(dimage(:,:,lS,lM))));
            end
    end
   
end