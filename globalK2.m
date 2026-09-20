function GK = globalK2(node,elem,node_new,elem_new,mat)
geom = computeGeometry(node,elem);               
nElem = numel(elem);                             
nNode2 = size(node_new,1);                       
nScalar = nNode2 + nElem;                        
locLen = zeros(nElem,1);                         
for iel = 1:nElem                                
    Nv = numel(elem{iel});                       
    locLen(iel) = 2*(2*Nv + 1);                  
end                                              
nnzEst = sum(locLen.^2);                         
ii = zeros(nnzEst,1);                            
jj = zeros(nnzEst,1);                            
ss = zeros(nnzEst,1);                            
pos = 0;                                         
for iel = 1:nElem                                
    Ke = elemK2(iel,node,elem,node_new,elem_new,geom,mat); 
    localScalar = [elem_new{iel}(:)', nNode2 + iel]; 
    indexDof = [localScalar, localScalar + nScalar]; 
    Nd = numel(indexDof);                        
    [rows,cols] = ndgrid(indexDof,indexDof);     
    range = pos + (1:Nd^2);                      
    ii(range) = rows(:);                         
    jj(range) = cols(:);                         
    ss(range) = Ke(:);                           
    pos = pos + Nd^2;                            
end                                              
GK = sparse(ii(1:pos),jj(1:pos),ss(1:pos),2*nScalar,2*nScalar); 
GK = 0.5*(GK + GK');                             
end                                              
