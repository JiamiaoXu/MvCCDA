function [Z, P] = proposed_method(X_multiview, Label_multiview, alpha, lambda1, lambda2, lambda3, sigma, dim, num_view)

L = Construct_L(Label_multiview); % the labels of common components
W = Construct_W(X_multiview, Label_multiview, sigma); % the local similarity matrix of objects

[Z,P] = train(alpha, lambda1, lambda2, lambda3, X_multiview, dim, num_view,  L, W);%,  Te_data, Te_Labels);
end


function [Z,P] = train(alpha, lambda1, lambda2, lambda3, X_multiview, dim, num_view, L, W)%,  Te_data, Te_Labels)
    
rand('state', 0);
num_sample = size(X_multiview{1}, 2);
P = cell(1, num_view); 
for m = 1 : num_view
   P{m} = rand(size(X_multiview{1}, 1), dim);
end
Z = rand(dim, num_sample);
    
count = 0; 
while(1)
    PTmp = P;
        
% updata common component Z
    for i = 1 : num_sample
        Ptmp1 = 0;
        ZPtmp = zeros(dim, 1);
        for j = 1 : num_sample
            Ptmp1 = Ptmp1 + W(i, j);
            ZPtmp = ZPtmp + W(i, j)*Z(:, j);
        end
        Z(:, i) = irrz(X_multiview, P, Z( :,i), alpha, lambda2, lambda3, dim, num_view, i, L(:, i), Ptmp1, ZPtmp);  %irr迭代得到当前w下的完备空间
    end
        
    % updata projection P
    for v = 1 : num_view
         P{v} = irrp(Z, P, X_multiview{v}, alpha, lambda1, num_sample, v);
    end
            
    count = count + 1;
        
    % convergence or not
    maxVal = 0;
    for m = 1 : num_view
        maxVal = max(norm((P{m}-PTmp{m}), 'fro'), maxVal);
    end
    if(maxVal < 5e-7 || count > 200)
        break;
    end
end
    
end


function z = irrz(X_multiview, P, z, alpha, lambda2, lambda3, dim, num_view, iter, l, Ptmp, ZPtmp)

r = cell(1, num_view);
Q = cell(1, num_view);
for v = 1 : num_view
   r{v} = z - (P{v}.')*X_multiview{v}(:, iter);
end

count = 0;
while(1)
    ztmp = z;
 
    for v = 1 : num_view
       Q{v} = 1/(norm(r{v}, 2)^2 + alpha^2);
    end
    
    a = (num_view*lambda2) + (num_view*lambda3*Ptmp)  + Q{1};
    b = P{1}.' * X_multiview{1}(:, iter) .* Q{1} + num_view*lambda2*l + num_view*lambda3*ZPtmp;
    for v = 2 : num_view
       a = a + Q{v};
       b = b + P{v}.' * X_multiview{v}(:, iter) .* Q{v};
    end
    z = (a * eye(dim))\b; 
    
    for v = 1 : num_view
        r{v} = z - (P{v}.')*X_multiview{v}(:, iter);
    end
    
    count = count + 1;
    if(norm((z-ztmp), 2) < 1e-4 || count > 200)         
        break;
    end  
end 

end


function p = irrp(Z, P, X, alpha, lambda1, num_sample, iter)

p = P{iter};
count = 0;
while(1)    
    ptmp = p;   
        
    XTmp = X.';
    ZTmp = Z.';
    for i = 1 : num_sample
        r_i = Z( :,i) - p.'*X( :,i);
        G_i = 1/((norm(r_i,2)^2) + alpha^2);
        XTmp(i,:) = XTmp(i,:) .* G_i; 
        ZTmp(i,:) = ZTmp(i,:) .* G_i;
    end
        
    p = (X * XTmp + num_sample*lambda1*eye(size(X, 1)))\(X * ZTmp);
        
    count = count + 1;
    if(norm((p-ptmp), 'fro') < 1e-4 || count > 200)
        break;
    end      
end

end