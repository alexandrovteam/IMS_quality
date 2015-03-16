function [val] = histmaxindex( hist_vals)
%Simply returns the second output from max
[~,val] = max(hist_vals(2:end));
val=val+1;