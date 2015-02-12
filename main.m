clc
clear all 
rdata = load('hw3_train.dat');
tdata = load('hw3_test.dat');
set(0,'RecursionLimit',1000);
global tree_count
global tree_map
global tree_nodes

tree_count = 1;
tree_map = [];
tree_nodes = {};

[G Gm1] = DecisionTree(rdata);

N = size(rdata,1);

h = [];
for i=1:N,
    leaf = DecisionTreeTest(rdata(i,:));
    h = [h; leaf];
end

y = rdata(:,end);

Ein = sum(y~=h)/N;


N = size(tdata,1);
h = [];
for i=1:N,
    leaf = DecisionTreeTest(tdata(i,:));
    h = [h; leaf];
end

y = tdata(:,end);

Eout = sum(y~=h)/N;