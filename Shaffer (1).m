data1 = [3.814, 3.792, 3.786, 3.822, 3.814, 3.854, 3.874, 3.929, 4.061, 4.057, 4.121];
data2 = [3.731, 3.73, 3.773, 3.781, 3.765, 3.683, 3.784, 3.818, 3.829, 3.925, 3.972];
data3 = [3.617, 3.595, 3.623, 3.603, 3.673, 3.696, 3.741, 3.719, 3.729, 3.851, 3.887];
data4 = [3.491, 3.581, 3.602, 3.579, 3.57, 3.58, 3.592, 3.677, 3.706, 3.718, 3.751];
data5 = [3.399, 3.314, 3.513, 3.48, 3.534, 3.499, 3.521, 3.647, 3.654, 3.665, 3.724];
data6 = [3.206, 3.081, 3.241, 3.097, 3.116, 3.196, 3.439, 3.512, 3.486, 3.522, 3.641];

data = {data1, data2, data3, data4, data5, data6};
n = length(data);
[pairs1, pairs2] = find(tril(ones(n), -1));
pairs = [pairs1, pairs2];
m = size(pairs, 1);

p_values = zeros(m, 1);
for k = 1:m
    [~, p_values(k)] = ttest2(data{pairs(k, 1)}, data{pairs(k, 2)});
end

[sorted_p_values, sort_idx] = sort(p_values);
adjusted_p_values = zeros(m, 1);

for k = 1:m
    remaining_hypotheses = m - k + 1;
    threshold = 0.05 / remaining_hypotheses;
    adjusted_p_values(sort_idx(k)) = min(1, sorted_p_values(k) * (m - k + 1));
end

for k = 1:m
    fprintf('比較 %d vs %d: p値 = %.5f, 補正後のp値 = %.5f - ', ...
            pairs(k, 1), pairs(k, 2), p_values(k), adjusted_p_values(k));
    if adjusted_p_values(k) < 0.05
        fprintf('有意差があります。\n');
    else
        fprintf('有意差はありません。\n');
    end
end
