function face = findFace(node,elem,nodeID)
nElem = numel(elem);                              
nNode = size(node,1);                             
mark = false(nNode,1);                            
mark(nodeID) = true;                              
face = zeros(0,2);                                
for iel = 1:nElem                                 
    ids = elem{iel};                              
    ids = ids(:)';                                
    Nv = numel(ids);                              
    for ie = 1:Nv                                 
        pair = [ids(ie), ids(mod(ie,Nv)+1)];      
        if mark(pair(1)) && mark(pair(2))         
            face = [face; iel, ie];               
        end                                       
    end                                           
end                                               
end                                               
