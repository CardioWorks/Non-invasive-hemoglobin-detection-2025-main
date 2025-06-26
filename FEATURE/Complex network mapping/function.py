import numpy as np
from scipy import signal,stats


def remove_edges_below_threshold(graph, k):
    edges_to_remove = []
    for (u, v, weight) in graph.edges(data='weight'):
        if weight < k:
            edges_to_remove.append((u, v))

    for (u, v) in edges_to_remove:
        graph.remove_edge(u, v)

    return graph

def statistical_feature_extraction(data):
    feature = np.zeros((1, 12))
    feature[0, 0] = np.max(data)
    feature[0, 1] = np.min(data)
    feature[0, 2] = np.mean(data)
    feature[0, 3] = np.median(data)
    feature[0, 4] = np.var(data)
    feature[0, 5] = stats.kurtosis(data)
    feature[0, 6] = np.percentile(data, 25)
    feature[0, 7] = stats.mode(data, axis=None, keepdims=True)[0][0]
    feature[0, 8] = np.max(data) - np.min(data)
    feature[0, 9] = np.std(data)
    feature[0, 10] = stats.skew(data)
    feature[0, 11] = np.percentile(data, 75)

    return feature