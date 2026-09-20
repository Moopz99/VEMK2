function cell_new = nodeReorder(cell_old)
n = size(cell_old, 1);
cell_new = cell(n, 1);
for i = 1:n                     
    nodes = cell_old{i};        
    total_nodes=length(nodes);  
    if mod(total_nodes, 2) == 0 
        n_vertices = total_nodes / 2;
        n_midpoints = total_nodes / 2;
    else
        disp('There is a problem with the number of nodes.');
        pause;
    end   
     vertices = nodes(1:n_vertices);
    midpoints = nodes(n_vertices+1:end);
    new_order = zeros(1, 2*n_vertices);
    for j = 1:n_vertices
        new_order(2*j-1) = vertices(j);
        new_order(2*j) = midpoints(j);
    end
    cell_new{i} = new_order;
end