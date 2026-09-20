function elem = normalizeElem(elemIn)
if iscell(elemIn)                               
    elem = elemIn;                              
    for iel = 1:numel(elem)                     
        ids = elem{iel};                        
        ids = ids(:)';                          
        ids = ids(~isnan(ids));                 
        elem{iel,1} = ids;                      
    end                                         
else                                            
    nElem = size(elemIn,1);                     
    elem = cell(nElem,1);                       
    for iel = 1:nElem                           
        ids = elemIn(iel,:);                    
        ids = ids(~isnan(ids));                 
        ids = ids(ids>0);                       
        elem{iel} = ids(:)';                    
    end                                         
end                                             
end                                             
