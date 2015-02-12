function [ th_all Accin_all d_all s_all ] = Decision_stump( data_X, data_y, u)
%DECISION_STUMP Summary of this function goes here
%   Detailed explanation goes here
data = [data_X data_y u];

[Np D]= size(data_X);
H1 = zeros(D,1);
H2 = zeros(D,1);
H1_m1 = zeros(D,1);
H2_m1 = zeros(D,1);
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
        for i=2:Np+1,
            y = data_set(i-1,end-1);
            u = data_set(i-1,end);
            %%1
            if 1~=y, 
                count = count + u; 
            else
                count = count - u;
            end
            if count>count_max, 
                count_max = count;
                if i~=Np+1
                    theta = (data_set(i-1,d) + data_set(i,d))*0.5;
                else
                    theta = data_set(i-1,d) + 0.5;
                end
            end
             
            %%-1
            if -1~=y, 
                count_m1 = count_m1 + u; 
            else
                count_m1 = count_m1 - u;
            end
            if count_m1>count_m1_max, 
                count_m1_max = count_m1;
                if i~=Np+1
                    theta_m1 = (data_set(i-1,d) + data_set(i,d))*0.5;
                else
                    theta = data_set(i-1,d) + 0.5;
                end
            end
        end
       %H = [H; theta count_max/Np]; 
        H1(d,1) = theta;
        H2(d,1) = count_max/Np;
        H1_m1(d,1) = theta_m1;
        H2_m1(d,1) = count_m1_max/Np;
    end
    H = [H1 H2];
    [v d] = max(H(:,2));
    th = H(d,1);
    Accin = H(d,2);
    H_m1 = [H1_m1 H2_m1];
    [v d_m1] = max(H_m1(:,2));
    th_m1 = H_m1(d_m1,1);
    Accin_m1 = H_m1(d_m1,2);
    temp = [th Accin d 1;th_m1 Accin_m1 d_m1 -1];
    [v ind] = max(temp(:,2));
    th_all = temp(ind,1);
    Accin_all = temp(ind,2);
    d_all = temp(ind,3);
    s_all = temp(ind,4);    
end

