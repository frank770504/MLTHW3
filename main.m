clc
clear all 
rdata = load('hw3_train.dat');
set(0,'RecursionLimit',1000);
global tree_count
global tree_map
global tree_nodes

tree_count = 1;
tree_map = [];
tree_nodes = {};

[G Gm1] = DecisionTree(rdata);