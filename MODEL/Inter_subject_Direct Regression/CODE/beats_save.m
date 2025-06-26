function result = beats_save(data,n)

rowMeans = trimmean(data, 40, 2);


[~, sortedIndices] = sort(rowMeans, 'descend');
indicesToKeep = sortedIndices(1:min(n, length(sortedIndices)));


result = data(indicesToKeep, :);
end