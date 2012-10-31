function W = assemble_proj_mtx(fullProjMtx, imageSize, angles)
    phantomImage = phantom(imageSize);
    k = size(radon(phantomImage,90),1);
    W = spalloc(length(angles)*k, imageSize^2, round(length(angles)*k*imageSize*sqrt(2)));
    idx = zeros(length(angles)*k,1);
    for i = 0:length(angles)-1
        idx(i*k+1:i*k+k) = angles(i+1)*k+1:angles(i+1)*k+k;
    end
    W(:,:) = fullProjMtx(idx,:);
end

