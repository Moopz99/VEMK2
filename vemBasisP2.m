function [val,strain,divStress] = vemBasisP2(point,centroid,h,C)
x = point(1);                                    
y = point(2);                                    
xK = centroid(1);                                
yK = centroid(2);                                
xi = (x - xK)/h;                                 
eta = (y - yK)/h;                                
invh = 1/h;                                      
invh2 = invh^2;                                  
val = zeros(2,12);                               
val(:,1)  = [1;0];                               
val(:,2)  = [0;1];                               
val(:,3)  = [-eta;xi];                           
val(:,4)  = [eta;xi];                            
val(:,5)  = [xi;0];                              
val(:,6)  = [0;eta];                             
val(:,7)  = [xi^2;0];                            
val(:,8)  = [xi*eta;0];                          
val(:,9)  = [eta^2;0];                           
val(:,10) = [0;xi^2];                            
val(:,11) = [0;xi*eta];                          
val(:,12) = [0;eta^2];                           
strain = zeros(3,12);                            
strain(:,3)  = [0;0;0];                          
strain(:,4)  = [0;0;2*invh];                     
strain(:,5)  = [invh;0;0];                       
strain(:,6)  = [0;invh;0];                       
strain(:,7)  = [2*xi*invh;0;0];                  
strain(:,8)  = [eta*invh;0;xi*invh];             
strain(:,9)  = [0;0;2*eta*invh];                 
strain(:,10) = [0;0;2*xi*invh];                  
strain(:,11) = [0;xi*invh;eta*invh];             
strain(:,12) = [0;2*eta*invh;0];                 
if nargin < 4 || isempty(C)                      
    divStress = zeros(2,12);                     
    return                                       
end                                              
dStrainDx = zeros(3,12);                         
dStrainDy = zeros(3,12);                         
dStrainDx(:,7)  = [2*invh2;0;0];                 
dStrainDy(:,8)  = [invh2;0;0];                   
dStrainDx(:,8)  = [0;0;invh2];                   
dStrainDy(:,9)  = [0;0;2*invh2];                 
dStrainDx(:,10) = [0;0;2*invh2];                 
dStrainDx(:,11) = [0;invh2;0];                   
dStrainDy(:,11) = [0;0;invh2];                   
dStrainDy(:,12) = [0;2*invh2;0];                 
divStress = zeros(2,12);                         
for a = 1:12                                     
    dsigDx = C*dStrainDx(:,a);                   
    dsigDy = C*dStrainDy(:,a);                   
    divStress(1,a) = dsigDx(1) + dsigDy(3);      
    divStress(2,a) = dsigDx(3) + dsigDy(2);      
end                                              
end                                              
