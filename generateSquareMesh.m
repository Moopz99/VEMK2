function [node,elem] = generateSquareMesh(nx,ny)
if nargin < 2                                    
    ny = nx;                                     
end                                              
node = zeros((nx+1)*(ny+1),2);                   
id = zeros(nx+1,ny+1);                           
count = 0;                                       
for j = 0:ny                                     
    for i = 0:nx                                 
        count = count + 1;                       
        id(i+1,j+1) = count;                     
        node(count,:) = [i/nx,j/ny];             
    end                                          
end                                              
elem = cell(nx*ny,1);                            
e = 0;                                           
for j = 1:ny                                     
    for i = 1:nx                                 
        e = e + 1;                               
        n1 = id(i,j);                            
        n2 = id(i+1,j);                          
        n3 = id(i+1,j+1);                        
        n4 = id(i,j+1);                          
        elem{e} = [n1,n2,n3,n4];                 
    end                                          
end                                              
end                                              
