function [val] = histR(I_rgb, eval_type, nbins )
% Calculate histogram of red channel
im=I_rgb(:,:,1);
[nelements,centers] = hist(im(~isnan(im)),0:0.1:1);
val = feval(eval_type,nelements);
