function val = himhist(I, eval_type, nbins )
% Calculate histogram of red channel
[nelements,centers] = histc(I(:),0:1/nbins:1);
figure, bar(0:1/nbins:1,nelements)
val = feval(eval_type,nelements)/nbins;
