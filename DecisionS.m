function [ theta D Ein_min Eout_min ] = DecisionS( data_set, s )
%DECISION_STUMP Summary of this function goes here
%   Detailed explanation goes here


dim = 2;
Np = size(data_set,1);
Ein_set = [];
Eout_set = [];
for D=1:dim,
    
    data_set = sortrows(data_set, D);

    Ein = 0;
    Ein_0 = 100;

    for j=2:Np,
        count = 0;
        theta = (data_set(j-1,D) + data_set(j,D))*0.5;
        for i=1:Np,
            x = data_set(i,D);
            h = s*sign(x - theta);
            y = data_set(i,end);
            if h~=y, count =count + 1; end
        end
        Ein = count/Np;
        if Ein>Ein_0, break; end
        Ein_0 = Ein;
    end

    if s==1,
       Eout(D) = 0.9*0.5*abs(theta) + 0.1*0.5*(2 - abs(theta)); 
    else
       Eout(D) = 1 - 0.9*0.5*abs(theta) - 0.1*0.5*(2 - abs(theta)); 
    end
    Ein_set = [Ein_set Ein_0];
    Eout_set = [Eout_set Eout];   
end
[Ein_min D] = min(Ein_set);
Eout_min = Eout(D);

end

