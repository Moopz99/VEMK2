function [KNew,FNew] = boundaryCondition(K,F,fixDof,giveDisp,method)
if nargin < 5                                    
    method = 1;                                  
end                                              
fixDof = fixDof(:);                              
giveDisp = giveDisp(:);                          
KNew = K;                                        
FNew = F;                                        
if method == 1                                   
    FNew = FNew - KNew(:,fixDof)*giveDisp;       
    FNew(fixDof) = giveDisp;                     
    KNew(fixDof,:) = 0;                          
    KNew(:,fixDof) = 0;                          
    KNew = KNew + sparse(fixDof,fixDof,ones(numel(fixDof),1),size(K,1),size(K,2)); 
else                                             
    alpha = max(abs(K(:))) * 1e8;                
    for i = 1:numel(fixDof)                      
        id = fixDof(i);                          
        KNew(id,id) = KNew(id,id) + alpha;       
        FNew(id) = FNew(id) + alpha*giveDisp(i); 
    end                                          
end                                              
end                                              