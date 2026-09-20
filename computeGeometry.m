function geom = computeGeometry(node,elem)
nElem = numel(elem);                            
geom.area = zeros(nElem,1);                     
geom.centroid = zeros(nElem,2);                 
geom.diameter = zeros(nElem,1);                 
geom.signedArea = zeros(nElem,1);               
for iel = 1:nElem                               
    ids = elem{iel};                            
    verts = node(ids,:);                        
    [a,c,sa] = polygonAreaCentroid(verts);       
    geom.area(iel) = a;                         
    geom.centroid(iel,:) = c;                   
    geom.diameter(iel) = polygonDiameter(verts);
    geom.signedArea(iel) = sa;                  
end                                             
end                                             
