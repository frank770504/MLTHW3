clc
clear all 
rdata = load('hw3_train.dat');
set(0,'RecursionLimit',1000)
DecisionTree(rdata);