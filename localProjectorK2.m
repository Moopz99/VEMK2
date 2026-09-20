function proj = localProjectorK2(elemID,node,elem,node_new,elem_new,geom,mat)
C = getElasticMatrix(mat);                       
vertsID = elem{elemID};                          
vertsID = vertsID(:)';                           
Nv = numel(vertsID);                             
physID = elem_new{elemID};                       
physID = physID(:)';                             
verts = node(vertsID,:);                         
physCoord = node_new(physID,:);                  
area = geom.area(elemID);                        
centroid = geom.centroid(elemID,:);              
h = geom.diameter(elemID);                       
Ns = 2*Nv + 1;                                   
Nd = 2*Ns;                                       
Np = 12;                                         
D = zeros(Nd,Np);                                
for a = 1:(2*Nv)                                  
    [val,~,~] = vemBasisP2(physCoord(a,:),centroid,h,C); 
    D(a,:) = val(1,:);                           
    D(Ns+a,:) = val(2,:);                        
end                                              
[qp,qw] = polygonQuadrature(verts,3);             
meanVal = zeros(2,Np);                           
for iq = 1:numel(qw)                              
    [val,~,~] = vemBasisP2(qp(iq,:),centroid,h,C);
    meanVal = meanVal + qw(iq)*val;              
end                                              
meanVal = meanVal/area;                          
D(2*Nv+1,:) = meanVal(1,:);                      
D(Ns+2*Nv+1,:) = meanVal(2,:);                   
B = zeros(Np,Nd);                                
[xiG,wG] = gaussLineRule3();                     
for ie = 1:Nv                                    
    id1 = ie;                                    
    idm = Nv + ie;                               
    id2 = mod(ie,Nv) + 1;                        
    x1 = node_new(physID(id1),:);                
    xm = node_new(physID(idm),:);                
    x2 = node_new(physID(id2),:);                
    Ne = [x2(2)-x1(2), x1(1)-x2(1)];             
    for ig = 1:numel(wG)                         
        s = xiG(ig);                             
        w = wG(ig);                              
        Nedge = [0.5*s*(s-1), 1-s^2, 0.5*s*(s+1)]; 
        xg = Nedge(1)*x1 + Nedge(2)*xm + Nedge(3)*x2; 
        [~,strain,~] = vemBasisP2(xg,centroid,h,C); 
        sigma = C*strain;                        
        tx = sigma(1,:)*Ne(1) + sigma(3,:)*Ne(2);
        ty = sigma(3,:)*Ne(1) + sigma(2,:)*Ne(2);
        loc = [id1,idm,id2];                     
        for a = 1:3                              
            B(:,loc(a)) = B(:,loc(a)) + ...      
                0.5*w*Nedge(a)*tx';              
            B(:,Ns+loc(a)) = B(:,Ns+loc(a)) + ...
                0.5*w*Nedge(a)*ty';              
        end                                      
    end                                          
end                                              
[~,~,divStressC] = vemBasisP2(centroid,centroid,h,C); 
for a = 1:Np                                     
    B(a,2*Nv+1) = B(a,2*Nv+1) - area*divStressC(1,a); 
    B(a,Ns+2*Nv+1) = B(a,Ns+2*Nv+1) - area*divStressC(2,a); 
end                                              
boundaryRows = [1:(2*Nv), Ns+(1:(2*Nv))];            
B0 = zeros(3,Nd);                                
for a = 1:3                                      
    B0(a,boundaryRows) = D(boundaryRows,a)'/numel(boundaryRows); 
end                                              
Bs = B;                                          
Bs(1:3,:) = B0;                                  
G = B*D;                                         
G = 0.5*(G + G');                                
Gs = Bs*D;                                       
Pis = Gs\Bs;                                    
Pi = D*Pis;                                      
proj.D = D;                                      
proj.B = B;                                      
proj.Bs = Bs;                                    
proj.G = G;                                      
proj.Gs = Gs;                                    
proj.Pis = Pis;                                  
proj.Pi = Pi;                                    
proj.area = area;                                
proj.centroid = centroid;                        
proj.diameter = h;                               
proj.Nv = Nv;                                    
proj.Ns = Ns;                                    
proj.Nd = Nd;                                    
proj.Np = Np;                                    
proj.verts = verts;                              
end                                              
function [x,w] = gaussLineRule3()
x = [-sqrt(3/5);0;sqrt(3/5)];                    
w = [5/9;8/9;5/9];                               
end                                              