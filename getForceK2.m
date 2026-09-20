function ff = getForceK2(node,elem,node_new,elem_new,press,direction)
nElem = numel(elem);                              
nNode2 = size(node_new,1);                        
nScalar = nNode2 + nElem;                         
ff = zeros(2*nScalar,1);                          
if isempty(press)                                 
    ff = sparse(ff);                              
    return                                        
end                                               
[xiG,wG] = gaussLineRule3();                      
for ip = 1:size(press,1)                          
    elemID = press(ip,1);                         
    faceID = press(ip,2);                         
    value = press(ip,3);                          
    Nv = numel(elem{elemID});                     
    physID = elem_new{elemID};                    
    id1 = faceID;                                 
    idm = Nv + faceID;                            
    id2 = mod(faceID,Nv) + 1;                     
    loc = [physID(id1), physID(idm), physID(id2)];
    x1 = node_new(loc(1),:);                      
    xm = node_new(loc(2),:);                      
    x2 = node_new(loc(3),:);                      
    edgeVec = x2 - x1;                            
    L = norm(edgeVec);                            
    normal = [edgeVec(2), -edgeVec(1)]/L;         
    fe = zeros(3,1);                              
    for ig = 1:numel(wG)                          
        s = xiG(ig);                              
        w = wG(ig);                               
        Nedge = [0.5*s*(s-1); 1-s^2; 0.5*s*(s+1)];
        fe = fe + w*Nedge*value*(L/2);            
    end                                           
    if strcmpi(direction,'normal')                
        ff(loc) = ff(loc) + fe*normal(1);         
        ff(loc+nScalar) = ff(loc+nScalar) + fe*normal(2); 
    elseif strcmpi(direction,'x')                 
        ff(loc) = ff(loc) + fe;                   
    elseif strcmpi(direction,'y')                 
        ff(loc+nScalar) = ff(loc+nScalar) + fe;   
    else                                          
        error('getForceK2:badDirection','direction must be x、y or normal'); 
    end                                           
end                                               
ff = sparse(ff);                                  
end                                               
function [x,w] = gaussLineRule3()
x = [-sqrt(3/5);0;sqrt(3/5)];                     
w = [5/9;8/9;5/9];                                
end                                               
