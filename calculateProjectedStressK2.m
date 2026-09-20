function [stress,mises,strainNode] = calculateProjectedStressK2(node,elem,node_new,elem_new,uh,mat)
C = getElasticMatrix(mat);                        
geom = computeGeometry(node,elem);                
nElem = numel(elem);                              
nNode2 = size(node_new,1);                        
nScalar = nNode2 + nElem;                         
stress = zeros(nNode2,3);                         
strainNode = zeros(nNode2,3);                     
count = zeros(nNode2,1);                          

for iel = 1:nElem                                 
    proj = localProjectorK2(iel,node,elem,node_new,elem_new,geom,mat); 
    localScalar = [elem_new{iel}(:)', nNode2 + iel]; 
    indexDof = [localScalar, localScalar+nScalar]; 
    coeff = proj.Pis * uh(indexDof);              
    ids = elem_new{iel};                          
    for a = 1:numel(ids)                          
        id = ids(a);                              
        [~,strainBasis,~] = vemBasisP2(node_new(id,:),proj.centroid,proj.diameter,C); 
        epsP = strainBasis*coeff;                 
        sig = C*epsP;                             
        strainNode(id,:) = strainNode(id,:) + epsP'; 
        stress(id,:) = stress(id,:) + sig';       
        count(id) = count(id) + 1;                
    end                                           
end                                               
count(count==0) = 1;                              
stress = stress ./ count;                         
strainNode = strainNode ./ count;                 
sxx = stress(:,1);                                
syy = stress(:,2);                                
txy = stress(:,3);                                
mises = sqrt(sxx.^2 - sxx.*syy + syy.^2 + 3*txy.^2); 
end                                               