function [ G1 Gm1 ] = DecisionTree( rdata )
%DECISIONTREE Summary of this function goes here
%   Detailed explanation goes here
    global tree_count
    global tree_map
    global tree_nodes
    x_tr = rdata(:,1:2);
    y_tr = rdata(:,end);
    
    Tree.count = tree_count; 
    
    
    if isyneq(y_tr)==0 || isxneq(x_tr)==0,
        if y_tr(1)==1,
            G1.D = rdata;
            G1.branch{1} = 0;
            G1.branch{2} = 0;
            Gm1 = sign(sum(y_tr)); %leaf
            Tree.leaf = Gm1;
            Tree.childL = -1;
            Tree.childR = -1;
        else
            Gm1.D = rdata;
            Gm1.branch{1} = 0;
            Gm1.branch{2} = 0;
            G1 = sign(sum(y_tr)); %leaf
            Tree.leaf = G1;
            Tree.childL = -1;
            Tree.childR = -1;            
        end
        Tree.dec = [-1 -1];
    else
        [Ntr D] = size(x_tr);
        u = ones(Ntr,1)./Ntr;
        [th d thind] = Decision_stump_Gind(x_tr,y_tr,u);
        Tree.dec = [th d];
        data = [x_tr y_tr];
        data_sort = sortrows(data,d);

        data_tr1 = data_sort(1:floor(thind),:);
        G1.D = data_tr1;
        G1.branch{1} = thind;
        G1.branch{2} = d;
        tree_count = tree_count + 1;
        Tree.childL = tree_count;
        DecisionTree(data_tr1);
        data_tr2 = data_sort(ceil(thind):end,:);
        Gm1.D = data_tr2;
        Gm1.branch{1} = thind;
        Gm1.branch{2} = d;
        tree_count = tree_count + 1;
        Tree.childR = tree_count;
        DecisionTree(data_tr2);
    end
        tree_map = [tree_map;Tree.count Tree.childL Tree.childR Tree.dec];
        tree_nodes{Tree.count} = Tree;
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

