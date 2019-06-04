function [accuracy, average] = testing(Te_data, Te_labels)

   num_view = size(Te_data, 2);  
   accuracy = zeros(num_view, num_view);   
   average = 0;
   
   for m = 1 : num_view
       for n = 1 : num_view
           if m ~= n
                Cls = knnclassify(Te_data{m}.',Te_data{n}.',Te_labels{n}, 1);
                acc = length(find(Cls==Te_labels{m}))/length(Te_labels{m})*100;
                accuracy(m, n) = acc;  
                average = average + acc;
           end
       end
   end
   
   average = average / (num_view * num_view - num_view);
end