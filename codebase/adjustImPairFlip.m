function ImPairs_adjusted = adjustImPairFlip( ImPairs, LRFlipValue )
%UNTITLED2 Summary of this function goes here
%   Change the left right position of image pair if corresponding flip value is true

ImPairs_adjusted = ImPairs;
flipped = ImPairs(LRFlipValue,:);
ImPairs_adjusted(LRFlipValue,:) = flipped(:,[2 1]);


end

