%
% Builds the projection matrix to do the radon transformation.
%
function Rmatrix = buildRadonMatrix(imageSize,thetaAngles)    
%% Get the size of the Radon transformation
phantomImage = phantom(imageSize);
k = size(radon(phantomImage,90),1);

%% Build the Radon matrix to do the forward projection
Rmatrix = zeros(length(thetaAngles)*k, imageSize^2);
for x=1:imageSize
    for y=1:imageSize
        
        % A delta function image
        deltaImage = zeros(imageSize);
        deltaImage(x,y) = 1;
        
        % Apply the Radon transformation for the delta function image
        p2DRadon = radon(deltaImage,thetaAngles);
        Rmatrix(:,(y-1)*imageSize + x) = p2DRadon(:);
    end
end
Rmatrix = sparse(Rmatrix);

end
