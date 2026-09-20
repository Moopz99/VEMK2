function [area,centroid,signedArea] = polygonAreaCentroid(verts)
vertsNext = circshift(verts,-1);                
crossVal = verts(:,1).*vertsNext(:,2) - ...     
           vertsNext(:,1).*verts(:,2);          
signedArea = 0.5 * sum(crossVal);               
area = abs(signedArea);                         
if area < eps                                   
    error('polygonAreaCentroid:zeroArea','The unit area is too small or the vertex order is abnormal.'); 
end                                             
centroid = sum((verts + vertsNext).*crossVal,1) ... 
           /(6*signedArea);                     
end                                             
