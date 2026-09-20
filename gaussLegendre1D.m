function [x,w] = gaussLegendre1D(n)
if n < 1                                         
    error('gaussLegendre1D:badOrder',' n must be a positive integer.'); 
end                                              
if n == 1                                        
    x = 0.5;                                     
    w = 1.0;                                     
    return                                       
end                                              

k = (1:n-1)';                                    
beta = 0.5 ./ sqrt(1 - (2*k).^(-2));             
T = diag(beta,1) + diag(beta,-1);                
[V,D] = eig(T);                                  
[xm,idx] = sort(diag(D));                        
wm = 2*(V(1,idx)').^2;                           
x = 0.5*(xm + 1);                                
w = 0.5*wm;                                      
x = x(:);                                        
w = w(:);                                        
end                                              
