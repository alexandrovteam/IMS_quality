function [val] = hentropy(p)
% Entropy from histogram output
p(p==0) = [];
p = p ./ sum(p);
val = -sum(p.*log2(p));