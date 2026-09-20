clear;                                           
clc;                                             
close all;                                                                        
load('cook.mat'); 
[elem_new,node_new,~]=getk2_elemnode(elem,node);
elem = normalizeElem(elem);                      
if exist('node_new','var') && exist('elem_new','var') 
    elem_new = normalizeElem(elem_new);          
else                                             
    [node_new,elem_new] = buildQuadraticMesh(node,elem); 
end                                              
mat.E = 1;                                       
mat.nu = 1/3;                                    
mat.plane = 'stress';                            
nElem = numel(elem);                             
nNode2 = size(node_new,1);                       
nScalar = nNode2 + nElem;                        
p = 0.0625;                                      
nodeL = find(node_new(:,1) < 0.001);             
nodeR = find(node(:,1) > 48 - 0.001);            
pface = findFace(node,elem,nodeR);               
press = [pface, p*ones(size(pface,1),1)];         
fixMes = [nodeL, zeros(numel(nodeL),1); ...       
          nodeL+nScalar, zeros(numel(nodeL),1)];  
F = getForceK2(node,elem,node_new,elem_new,press,'y'); 
GK = globalK2(node,elem,node_new,elem_new,mat);   
[GK,F] = boundaryCondition(GK,F,fixMes(:,1),fixMes(:,2),1); 
uh = GK\F;                                       
uh = full(uh);                                   
ux = uh(1:nNode2);                               
uy = uh(nScalar+1:nScalar+nNode2);               
[stress,mises] = calculateProjectedStressK2(node,elem,node_new,elem_new,uh,mat);                           
rightPhysical = find(node_new(:,1) > 48 - 0.001); 
[maxUy,idxLocal] = max(uy(rightPhysical));        
tipNode = rightPhysical(idxLocal);                               
figure;                                          
Relem_new= nodeReorder(elem_new);
showsolution_k2(node_new+[ux,uy],Relem_new,uy);