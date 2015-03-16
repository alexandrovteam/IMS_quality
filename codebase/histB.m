function [val] = histB(I_rgb,eval_type, nbins )
% Calculate histogram of blue channel
im=I_rgb(:,:,3);
[nelements,centers] = hist(im(~isnan(im)),0:0.1:1);
val = feval(eval_type,nelements);
