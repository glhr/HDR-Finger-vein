function hd = lee_hd(codeA,maskA,codeB,maskB)
% Calculate Hamming distance.
% Watch out! Lee et al. uses an OR function in their paper, but this would
% mean that the value for HD can be larger than one. In the cited document
% of (Daugman,2004) an AND function is used. This is correct as the value
% for HD will lays between 0 and 1, for this reason the AND function has
% been used instead of the OR function.

% Parameters:
%  codeA - LBP of input image
%  maskA - Area which matters
%  codeB - LBP of reference image
%  maskB - Area which matters

% Returns:
%  hd - Hamming distance

% Reference:
% Finger vein recognition using minutia-based alignment and local binary
%   pattern-based feature extraction
% E.C. Lee, H.C. Lee and K.R. Park
% International Journal of Imaging Systems and Technology
%   Volume 19, Issue 3, September 2009, Pages 175-178   
% doi: 10.1002/ima.20193

% Author:  Bram Ton <b.t.ton@alumnus.utwente.nl>
% Date:    16th March 2012
% License: This work is licensed under a Creative Commons
%          Attribution-NonCommercial-ShareAlike 3.0 Unported License

mattering = bitand(maskA,maskB);
num = bitand(bitxor(codeA,codeB),mattering);
hd = 1 - sum(sum(de2bi(num,8)))/sum(sum(de2bi(mattering,8)));