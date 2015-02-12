function [ th_all d_all thind_all ] = Decision_stump_Gind( data_X, data_y, u)
%DECISION_STUMP Summary of this function goes here
%   Detailed explanation goes here
data = [data_X data_y];

[Np D]= size(data_X);
H1 = zeros(D,4);
% H2 = zeros(D,1);
% H1_m1 = zeros(D,1);
% H2_m1 = zeros(D,1);
%H = [];
    %parfor d=1:D,
    for d=1:D,
        data_set = sortrows(data, d);
%        figure
%         plot(data_set(:,d), data_set(:,3))
%         axis([0 1 -1.5 1.5])
        
        y_tr_sort = data_set(:,end);
        x_tr_sort = data_set(:,1:D);
       
        Gind_col = [];
        for i=1:Np-1,
            gini = Gind(y_tr_sort, i);
            Gind_col = [Gind_col;gini i+0.5];
        end

        Gind_col = sortrows(Gind_col,1);
        
        thind = Gind_col(1,2);
        theta = (x_tr_sort(floor(thind),d) + x_tr_sort(ceil(thind),d))/0.5;
        minG = Gind_col(1,1);
        H1(d,1) = theta;
        H1(d,2) = thind;
        H1(d,3) = d;
        H1(d,4) = minG;
    end
    H = sortrows(H1,4);
    th_all = H(1,1);
    d_all = H(1,3);
    thind_all = H(1,2);    
end

function [gini G1 G2] = Gind(y, i)
    G1.y = y(1:i);
    G1.N = size(G1.y,1);
    G2.y = y(i+1:end);
    G2.N = size(G2.y,1);
    
    G1.frac1 = (sum(G1.y==ones(G1.N,1))/G1.N)^2;
    G1.fracm1 = (sum(G1.y==(ones(G1.N,1).*-1))/G1.N)^2;
    G1.gini = 1 - G1.frac1 - G1.frac1;
    G2.frac1 = (sum(G2.y==ones(G2.N,1))/G2.N)^2;
    G2.fracm1 = (sum(G2.y==(ones(G2.N,1).*-1))/G2.N)^2;
    G2.gini = 1 - G2.frac1 - G2.frac1;
    
    gini = G1.N*G1.gini + G2.N*G2.gini;
end