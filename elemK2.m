function [Ke,proj] = elemK2(elemID,node,elem,node_new,elem_new,geom,mat)
proj = localProjectorK2(elemID,node,elem,node_new,elem_new,geom,mat); 
Pis = proj.Pis;                                  
Pi = proj.Pi;                                    
G = proj.G;                                      
Nd = proj.Nd;                                    

Ke_c = Pis' * G * Pis;                           
Ke_c = 0.5*(Ke_c + Ke_c');                       
I = eye(Nd);                                     
if isfield(mat,'stabCoef')                       
    tau = mat.stabCoef;                          
else                                             
    tau = 0.5;                                   
end                                              
if trace(Ke_c) > eps                             
    alpha = tau * trace(Ke_c);                   
else                                             
    alpha = tau * mat.E;                         
end                                              
Ke_s = alpha * ((I - Pi)' * (I - Pi));           
Ke = Ke_c + Ke_s;                                
Ke = 0.5*(Ke + Ke');                             
proj.Kc = Ke_c;                                  
proj.Ks = Ke_s;                                  
proj.alpha = alpha;                              
end                                              
