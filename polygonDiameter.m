function h = polygonDiameter(verts)
n = size(verts,1);                              
h = 0.0;                                       
for i = 1:n                                    
    for j = i+1:n                              
        dij = norm(verts(i,:) - verts(j,:));   
        if dij > h                             
            h = dij;                           
        end                                    
    end                                        
end                                            
end                                            
