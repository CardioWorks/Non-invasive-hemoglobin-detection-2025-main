function result = beats_save(data,n)
% Calculate the truncated mean for each row.
rowMeans = trimmean(data, 40, 2);

% Generate indexes based on the number of rows retained n
[~, sortedIndices] = sort(rowMeans, 'descend');
indicesToKeep = sortedIndices(1:min(n, length(sortedIndices)));

% Output a matrix containing n rows of results.
result = data(indicesToKeep, :);
end