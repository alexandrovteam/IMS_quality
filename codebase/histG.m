function [val] = histG(I_rgb,eval_type, nbins )
% Calculate histogram of green channel
im=I_rgb(:,:,2);
[nelements,centers] = histc(im(~isnan(im)),0:0.1:1);
val = feval(eval_type,nelements);
