function indices = is_in_range_zero_one(features)

in_range = (features >= 0 & features <= 1);

indices = find(sum(in_range) == size(features, 1));

end