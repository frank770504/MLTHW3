clc
clear all 
rdata = load('hw2_adaboost_train.dat');
X_tr = rdata(:,1:2);
y_tr = rdata(:,end);

Ntr = size(X_tr,1);
T = 300;
H = [];
u = ones(Ntr,1)./Ntr;
%u = ones(Ntr,1);
eps_set = [];
tic
for t=1:T,
    temp = [];
    [th Acc d] = Decision_stump(X_tr, y_tr, u, 1);
    temp = [temp;th Acc d 1];
    [th Acc d] = Decision_stump(X_tr, y_tr, u, -1);
    temp = [temp;th Acc d -1];

    [v ind] = max(temp(:,2));

    th = temp(ind,1);
    d = temp(ind,3);
    s = temp(ind,4);
    
    count = 0;
    
    for i=1:Ntr,
        x = X_tr(i,d);
        y = y_tr(i);
        h = s*sign(x - th);
        u_v = u(i);
        if h~=y, count = count + u_v; end
    end
    
    eps = count/sum(u);
    eps_set = [eps_set;eps];
    alpha = 0.5*log((1 - eps)/eps);

    for i=1:Ntr,
        x = X_tr(i,d);
        y = y_tr(i);
        h = s*sign(x - th);
        u(i) = u(i)*exp(-alpha*y*h);
    end
    H = [H;th d s alpha];   
end
toc
rdata = load('hw2_adaboost_test.dat');
X_te = rdata(:,1:2);
y_te = rdata(:,end);
Nte = size(X_te,1); 
cc = 0;
for i=1:Nte,
    H_tr = 0;
    y = y_te(i);
    
    for t=1:T,
        th = H(t,1);
        d = H(t,2);
        s = H(t,3);
        alpha = H(t,4);
        x = X_te(i,d);
        h = s*sign(x - th);
        H_tr = H_tr + h*alpha;
    end
    if y~=sign(H_tr), cc = cc +1; end
end
fprintf('Eout is %2.8f\n', cc/Nte);

figure
Z = X_tr;
hold on
for i=1:Ntr,
    if y_tr(i)>0,
        plot(Z(i,1), Z(i,2),'+');
    else
        plot(Z(i,1), Z(i,2), 'rx');
    end
end
