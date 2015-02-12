clc
clearvars -except Frorest_col
% load Frorest_col
rdata = load('hw3_train.dat');
tdata = load('hw3_test.dat');

N_tr = size(rdata,1);
N_te = size(tdata,1);
y_te = tdata(:,end);
y_tr = rdata(:,end);

global tree_nodes

T = 300;
h_rf_col = [];
E_col = [];
for i=1:100,
    fprintf('The current progress is %d\n', i);
    fprintf('\n');
    Forest = Frorest_col{i};
    h_forest = [];
    for t=1:T,
        N_bs = N_te;

        tree_nodes = Forest{t};
        
        h = [];
        for i=1:N_bs,
            leaf = DecisionTreeTest(tdata(i,:));
            h = [h; leaf];
        end
        
        h_forest = [h_forest h]; 
        if mod(t,30)==0,
            fprintf('.');
        end
    end
    fprintf('\n');
    h_rf = sign(sum(h_forest')');
    h_rf_col = [h_rf_col h_rf];
    Eout = sum(y_te~=h_rf)/N_te;
    E_col = [E_col;Eout];
end

mean(E_col)