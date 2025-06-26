import csv
import os
import numpy as np
import ReadFile
from scipy import signal,stats
import statistics
import matplotlib.pyplot as plt
import networkx as nx
import function
import community  
from scipy.spatial.distance import euclidean
from sklearn import preprocessing


path_data = './DATA/4.mat'  
path_save = "./OUTPUT/"    
id = path_data.rstrip('.mat')  
id = int(''.join(filter(str.isdigit, id))) 

features_networkx = np.zeros((1, 14))

# Read PPG data
ppgdata_1,ppgdata_2,ppgdata_3,ppgdata_4= ReadFile.Read_fourwave(path_data)
ppgdata_1 = np.transpose(ppgdata_1)
ppgdata_2 = np.transpose(ppgdata_2)
ppgdata_3 = np.transpose(ppgdata_3)
ppgdata_4 = np.transpose(ppgdata_4)
# ppgdata_1 = preprocessing.scale(ppgdata_1)
# ppgdata_2 = preprocessing.scale(ppgdata_2)
# ppgdata_3 = preprocessing.scale(ppgdata_3)
# ppgdata_4 = preprocessing.scale(ppgdata_4)

# sample frequency 200 Hz
fs = 200

# Divide PPG into 10-second intervals and calculate basic characteristics.
n_samples = len(ppgdata_1)
segment_size = 2 * fs
n_segments = int(np.floor(n_samples / segment_size))
ppg_segments = np.zeros((4, n_segments*12))

for s in range(n_segments):
    ppg_segment1 = ppgdata_1[s*segment_size:(s+1)*segment_size]
    sta_feature1 = function.statistical_feature_extraction(ppg_segment1)
    ppg_segments[0, s*12:s*12+12] = sta_feature1

for s in range(n_segments):
    ppg_segment2 = ppgdata_2[s*segment_size:(s+1)*segment_size]
    sta_feature2 = function.statistical_feature_extraction(ppg_segment2)
    ppg_segments[1, s*12:s*12+12] = sta_feature2

for s in range(n_segments):
    ppg_segment3 = ppgdata_3[s * segment_size:(s + 1) * segment_size]
    sta_feature3 = function.statistical_feature_extraction(ppg_segment3)
    ppg_segments[2, s*12:s*12+12] = sta_feature3

for s in range(n_segments):
    ppg_segment4 = ppgdata_4[s * segment_size:(s + 1) * segment_size]
    sta_feature4 = function.statistical_feature_extraction(ppg_segment4)
    ppg_segments[3, s*12:s*12+12] = sta_feature4

# Calculate the similarity between basic features and construct a weighted undirected graph.
n_features = ppg_segments.shape[1]
W = np.zeros((4, 4))
for i in range(4):
    for j in range(i, 4):
        # similarity = np.sum(np.abs(ppg_segments[i,:] - ppg_segments[j,:])) / n_features
        similarity = np.linalg.norm(ppg_segments[i,:]- ppg_segments[j,:])#欧氏距离
        # similarity = euclidean(ppg_segments[i,:], ppg_segments[j,:])#标准欧氏距离
        # similarity, p_value = stats.pearsonr(ppg_segments[i,:],ppg_segments[j,:])#pearson相关性
        W[i,j] = similarity
        W[j,i] = similarity
# G = nx.Graph(W)
# k = 0
# G = function.remove_edges_below_threshold(G, k)


G = nx.Graph()

# add nodes
num_nodes = W.shape[0]
G.add_nodes_from(range(num_nodes))

# Iterate through the adjacency matrix, adding edges and weights.
for i in range(num_nodes):
    for j in range(i + 1, num_nodes): 
        if W[i, j] != 0:
            G.add_edge(i, j, weight=W[i, j])

max_edge = np.max(W)
k = max_edge*0.3
G = function.remove_edges_below_threshold(G, k)

# Obtain edge weight information
edge_weights = [G[u][v]['weight'] for u, v in G.edges()]

# Define layout algorithms to automatically arrange node positions.
pos = nx.spring_layout(G)

# Zoom in on the width of the edges to enhance the visualization effect.
edge_widths = [w * 10 for w in edge_weights]


nx.draw(G, pos, with_labels=True, node_color='lightblue', node_size=500, width=edge_widths, edge_color='gray')


plt.show()

# Extracting PPG features
degree = dict(nx.degree(G,weight='weight'))
avg_degree = sum(degree.values())/len(G.nodes)
cc = nx.clustering(G,weight='weight')
weighted_cc = nx.average_clustering(G, weight='weight')
diameter = nx.diameter(G,weight='weight')
L = nx.average_shortest_path_length(G,weight='weight')
wiener = nx.wiener_index(G,weight='weight')

# partition = community.best_partition(G,weight='weight')

# modularity = community.modularity(partition, G,weight='weight')




values_degree = [degree[key] for key in sorted(degree.keys())]
values_cc = [cc[key] for key in sorted(cc.keys())]

features_degree = np.array([values_degree])
features_cc = np.array([values_cc])

features_networkx[0,0] = id
features_networkx[0,1:5] = features_degree
features_networkx[0,5] = avg_degree
features_networkx[0,6:10] = features_cc
features_networkx[0,10] = weighted_cc
features_networkx[0,11] = diameter
features_networkx[0,12] = L
features_networkx[0,13] = wiener

# output features
print("Degree and degree distribution: ", degree)
print("Average connectivity: ", avg_degree)
print("Empowerment clustering coefficient: ", cc)
print("average clustering coefficient: ", weighted_cc)
print("network diameter: ", diameter)
print("average shortest path length: ", L)
print("Wiener coe: ", wiener)



# save_image_path = os.path.join(path_save,  f'{str(id)}.png')
# plt.savefig(save_image_path, dpi = 300, bbox_inches='tight')
#
# save_csv_path = os.path.join(path_save,  f'{str(id)}.csv') 

# with open(save_csv_path, 'w', newline='') as file:
#     writer = csv.writer(file)
#     writer.writerows(features_networkx)