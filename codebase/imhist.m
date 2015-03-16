function val = imhist(I, eval_type, nbins )
% Calculate histogram of red channel
[nelements,centers] = histc(I(:),0:0.1:1);
val = feval(eval_type,nelements);
