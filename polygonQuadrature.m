function [qp,qw] = polygonQuadrature(verts,order)
if nargin < 2                                    
    order = 8;                                   
end                                              
[~,centroid] = polygonAreaCentroid(verts);       
[xg,wg] = gaussLegendre1D(order);                
Nv = size(verts,1);                              
qp = zeros(Nv*order*order,2);                    
qw = zeros(Nv*order*order,1);                    
cnt = 0;                                         
for ie = 1:Nv                                    
    a = verts(ie,:);                             
    b = verts(mod(ie,Nv)+1,:);                   
    J = abs(det([a-centroid; b-centroid]));       
    for ir = 1:order                             
        r = xg(ir);                              
        wr = wg(ir);                             
        for is = 1:order                         
            eta = xg(is);                        
            ws = wg(is);                         
            s = (1-r)*eta;                       
            pt = centroid + r*(a-centroid) + s*(b-centroid); 
            weight = wr*ws*(1-r)*J;              
            cnt = cnt + 1;                       
            qp(cnt,:) = pt;                      
            qw(cnt) = weight;                    
        end                                      
    end                                          
end                                              
qp = qp(1:cnt,:);                                
qw = qw(1:cnt);                                  
end                                              
