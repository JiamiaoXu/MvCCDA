function W = Construct_W(X_multiview, Label_multiview, sigma)

    num_sample = size(X_multiview{1}, 2);
    num_view = size(X_multiview, 2);
    Labels = Label_multiview{1};
    
    W = zeros(num_sample, num_sample);
    for i = 1 : num_view
        W = W + calculate_S(X_multiview{i}, sigma);
    end
    W = W./num_view;
    
    for i = 1 : num_sample
       for j = 1 : num_sample
          if Labels(i)~= Labels(j)
              W(i,j) = 0;
          end
       end
    end
    
end

function S_v = calculate_S(X, sigma)

    num_sample = size(X, 2);
    S_v = zeros(num_sample, num_sample);
    
    for i = 1 : num_sample
       for j = 1 : num_sample
           S_v(i,j) = exp(-(norm(X(:,i)-X(:,j), 2)^2)/sigma);
       end
    end
    
end


