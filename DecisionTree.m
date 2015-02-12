function [ G1 Gm1 ] = DecisionTree( rdata )
%DECISIONTREE Summary of this function goes here
%   Detailed explanation goes here
    x_tr = rdata(:,1:2);
    y_tr = rdata(:,end);
     
    if isyneq(y_tr)==0 || isxneq(x_tr)==0,
        if y_tr(1)==1,
            G1.D = rdata;
            G1.branch{1} = 0;
            G1.branch{2} = 0;
            G1.branch{3} = 0; 
            Gm1 = [];
        else
            Gm1.D = rdata;
            Gm1.branch{1} = 0;
            Gm1.branch{2} = 0;
            Gm1.branch{3} = 0;
            G1 = [];
        end
    else
        [Ntr D] = size(x_tr);
        u = ones(Ntr,1)./Ntr;
        [thind d s] = Decision_stump_Gind(x_tr,y_tr,u);
        data = [x_tr y_tr];
        data_sort = sortrows(data,d);
%         x_tr_sort = data_sort(:,1:D);
%         y_tr_sort = data_sort(:,end);
%         TH = abs(ones(Ntr,1).*th - x_tr_sort(:,d));
%         [v ind] = min(TH);
%         if x_tr_sort(ind,d)>= th,
%             marg_ind = ind - 1;
%         else
%             marg_ind = ind;
%         end

        h_tr_sort = [ ones(floor(thind),1).*-s;ones(Ntr-floor(thind),1).*s ];

        data_tr1 = data_sort(1:floor(thind),:);
        G1.D = data_tr1;
        G1.branch{1} = thind;
        G1.branch{2} = d;
        G1.branch{3} = s;
        [G1 Gm1] = DecisionTree(data_tr1);
        data_tr2 = data_sort(ceil(thind):end,:);
        Gm1.D = data_tr2;
        Gm1.branch{1} = thind;
        Gm1.branch{2} = d;
        Gm1.branch{3} = s;
        [G1 Gm1] = DecisionTree(data_tr2);
    end
 
end

function [ o ] = isyneq(y_tr)
    o = sum(y_tr + 1)*sum(y_tr - 1);
end

function [ o ] = isxneq(x_tr)
    o = trace(cov(x_tr));
    if o<0.00000001,
        o = 0;
    end
end

