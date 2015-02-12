function [ th_all d_all s_all ] = Decision_stump_Gind( data_X, data_y, u)
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
        count = 0;
        count_max = 0;
        count_m1 = 0;
        count_m1_max = 0;
        theta = 0;
        theta_m1 = 0;
        
        y_tr_sort = data_set(:,end);
        
        y_poss = ones(Np,1);
        y_poss_col = [];
        Gind_col = [];
        for i=1:Np-1,
            if i==0,
                y_temp = y_poss;
                y_poss_col = [y_poss_col y_poss];
            else
                y_temp = y_poss;
                y_temp(1:i) = y_temp(1:i).*-1;
                y_poss_col = [y_poss_col y_temp];
            end
            [Gs1 Gsm1] = Gind(y_tr_sort, y_temp, i);
            Gind_col = [Gind_col;Gs1 Gsm1 i+0.5];
        end
%         for i=2:Np+1,
%             y = data_set(i-1,end-1);
%             u = data_set(i-1,end);
%             %%1
%             if 1~=y, 
%                 count = count + u; 
%             else
%                 count = count - u;
%             end
%             if count>count_max, 
%                 count_max = count;
%                 if i~=Np+1
%                     theta = (data_set(i-1,d) + data_set(i,d))*0.5;
%                 else
%                     theta = data_set(i-1,d) + 0.5;
%                 end
%             end
%              
%             %%-1
%             if -1~=y, 
%                 count_m1 = count_m1 + u; 
%             else
%                 count_m1 = count_m1 - u;
%             end
%             if count_m1>count_m1_max, 
%                 count_m1_max = count_m1;
%                 if i~=Np+1
%                     theta_m1 = (data_set(i-1,d) + data_set(i,d))*0.5;
%                 else
%                     theta = data_set(i-1,d) + 0.5;
%                 end
%             end
%         end
       %H = [H; theta count_max/Np]; 
       if size(Gind_col,1)==1,
           val = Gind_col(1:2);
           ind = 1;
       else
           [val ind] = min(Gind_col);
       end
       if val(1)==val(2),
           minG = val(1);
           [va in] = max(ind);
           theta = va + 0.5;
           if in==1, s = 1; end
           if in==2, s = -1; end
       else
           [va in] = min(val);
           minG = va;
           if size(Gind_col,1)==1,
               theta = ind + 0.5;
           else
                theta = ind(in) + 0.5;
           end
           if in==1, s = 1; end
           if in==2, s = -1; end
       end
       
        H1(d,1) = theta;
        H1(d,2) = s;
        H1(d,3) = d;
        H1(d,4) = minG;
    end
    H = sortrows(H1,4);
    th_all = H(1,1);
    d_all = H(1,3);
    s_all = H(1,2);    
end

function [Gs1 Gsm1] = Gind(y, h, i)
    N = size(y,1);
    hs1 = h; Nm1 = i; N1 = N - i;
    if i==0,
        gm1 =  0;
    else
        gm1 =  (sum((y(1:i)==hs1(1:i)))/N).^2;
    end
    g1 =  (sum((y(i+1:N)==hs1(i+1:N)))/N).^2;
    Gs1 = 1 - gm1 - g1;
    
    hsm1 = h.*-1; N1 = i; Nm1 = N - i;
    if i==0,
        gm1 = 0;
    else
        gm1 =  (sum((y(1:i)==hsm1(1:i)))/N).^2;
    end
    g1 =  (sum((y(i+1:N)==hsm1(i+1:N)))/N).^2;    
    Gsm1 = 1 - gm1 - g1;
end