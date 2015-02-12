function [ leaf ] = DecisionTreeTest( x )
%DECISIONTREETEST Summary of this function goes here
%   Detailed explanation goes here
    global tree_nodes

    ind = 1;
    NOT_GET_LEAF = 1;
    while(NOT_GET_LEAF)
        Tree = tree_nodes{ind};
        if Tree.childL==-1 || Tree.childR==-1,
            leaf = Tree.leaf;
            break;
        else
            th = Tree.dec(1);
            d = Tree.dec(2);
            if x(d)<=th,
                ind = Tree.childL;
            else
                ind = Tree.childR;
            end
    end
    
end

