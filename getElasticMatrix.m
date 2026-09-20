function C = getElasticMatrix(mat)
E = mat.E;                                      
nu = mat.nu;                                    
if isfield(mat,'plane')                         
    planeType = lower(mat.plane);               
else                                            
    planeType = 'stress';                       
end                                             

if strcmp(planeType,'strain')                   
    C = E*(1-nu)/((1+nu)*(1-2*nu)) * ...        
        [1,nu/(1-nu),0; ...                     
         nu/(1-nu),1,0; ...                     
         0,0,(1-2*nu)/(2*(1-nu))];              
else                                            
    C = E/(1-nu^2) * ...                        
        [1,nu,0; ...                            
         nu,1,0; ...                            
         0,0,(1-nu)/2];                         
end                                             
end                                             
