clc
clear all 

global tree_count
global tree_map
global tree_nodes

rdata = load('hw3_train.dat');
tdata = load('hw3_test.dat');
set(0,'RecursionLimit',1000);

N_tr = size(rdata,1);
N_te = size(tdata,1);
y_te = tdata(:,end);

E_in_col = [];
E_out_col = [];
Frorest_col = {};
for k=1:100,
    fprintf('this is in %d\n',k);
    T = 300;
    
    E_in_bs_col = [];
    Forest={};

    for t=1:T,
        tree_count = 1;
        tree_map = [];
        tree_nodes = {};
        N_bs = N_tr;
        ind = round(rand(N_bs,1).*100 + 0.5);

        boosdata = rdata(ind,:);

        y_tr = boosdata(:,end);

        [G Gm1] = DecisionTreePas1(boosdata);
        Forest{t} = tree_nodes;
        h = [];
        for i=1:N_bs,
            leaf = DecisionTreeTest(boosdata(i,:));
            h = [h; leaf];
        end

        Ein = sum(y_tr~=h)/N_bs;
        E_in_bs_col = [E_in_bs_col;Ein];

%         h = [];
%         for i=1:N,
%             leaf = DecisionTreeTest(tdata(i,:));
%             h = [h; leaf];
%         end
% 
%         Eout = sum(y~=h)/N;

    end
    E_in_col = [E_in_col E_in_bs_col];
    Frorest_col{k} = Forest;
end