function [elem_new,node_new,edgeMap] = getk2_elemnode(elem,node)
maxNode = size(node, 1);
edgeMap = containers.Map('KeyType', 'char', 'ValueType', 'double');
newNodes = [];
for i = 1:numel(elem)
    vertices = elem{i}; 
    nVertices = numel(vertices); 
    midPoints = zeros(1,nVertices);   
    for j = 1:nVertices     
        v1 = vertices(j);
        v2 = vertices( mod(j,nVertices)+1 ); 
        edgeKey = sprintf('%d_%d', min(v1,v2), max(v1,v2));
        if isKey(edgeMap, edgeKey)
            midPoints(j) = edgeMap(edgeKey);
        else
            maxNode = maxNode + 1;          
            coord1 = node(v1, :);           
            coord2 = node(v2, :);           
            midCoord = (coord1 + coord2)/2.0; 
            edgeMap(edgeKey) = maxNode;     
            midPoints(j) = maxNode;         
            newNodes = [newNodes; midCoord];
        end
    end
    elem_new{i} = [vertices,midPoints];
end
elem_new=elem_new';
node_new = [node; newNodes];
end

