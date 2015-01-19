function n_ratings = checkNumberRatings(pairRatingsSummary,slider_value_column_idx)

ratings_values = pairRatingsSummary(:,slider_value_column_idx);
n_ratings = sum(~isnan(ratings_values),2);
