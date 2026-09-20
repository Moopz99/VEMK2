function [node_new,elem_new,edge] = buildQuadraticMesh(node,elem)
nNode = size(node,1);                            
nElem = numel(elem);                             
node_new = node;                                 
elem_new = cell(nElem,1);                        
edgeMap = containers.Map('KeyType','char','ValueType','double'); 
edge.nodes = zeros(0,2);                         
edge.mid = zeros(0,1);                           
for iel = 1:nElem                                
    verts = elem{iel};                           
    verts = verts(:)';                           
    Nv = numel(verts);                           
    mids = zeros(1,Nv);                          
    for ie = 1:Nv                                
        a = verts(ie);                           
        b = verts(mod(ie,Nv)+1);                 
        key = sprintf('%d_%d',min(a,b),max(a,b));
        if isKey(edgeMap,key)                    
            mids(ie) = edgeMap(key);             
        else                                     
            midCoord = 0.5*(node(a,:) + node(b,:)); 
            node_new = [node_new; midCoord];     
            midID = size(node_new,1);            
            edgeMap(key) = midID;                
            mids(ie) = midID;                    
            edge.nodes = [edge.nodes; min(a,b),max(a,b)]; 
            edge.mid = [edge.mid; midID];        
        end                                      
    end                                          
    elem_new{iel} = [verts,mids];                
end                                              
edge.nVertexNode = nNode;                        
edge.nQuadraticNode = size(node_new,1);          
end                                              
