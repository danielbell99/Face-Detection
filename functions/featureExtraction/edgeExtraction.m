% EDGE EXTRACTION USING NEIGHBOURHOOD OPERATORS

function [EdgesOut, IhorOut, IverOut] = edgeExtraction(ImagesIn)
% Extracts horizontal and vertical gradients, and combined edged per image
% Wrap-around cuntion, calls upon extractEdges() and testEdgeExtraction()
% Using masks for convolution

B1 = [-1 0 1; -1 0 1; -1 0 1]; % Mask - extracts Vertical gradients
B2 = [-1 -1 -1, 0 0 0, 1 1 1]; % Mask - extracts Horizontal gradients

[EdgesOut, IhorOut, IverOut] = deal([])
for idx = 1 : 18 : length(ImagesIn) % extract 1 image at a time for task
    Iin = ImagesIn(:,idx:(idx+17)); % image = 18 cols
    [Edges, Ihor, Iver] = extractEdges(Iin, B1, B2); % extracted edges
    EdgesOut = [EdgesOut, Edges]; % append Edges to array for return
    IhorOut = [IhorOut, Ihor]; % append Ihor
    IverOut = [IverOut, Iver]; % append Iver
end
[Edges, Ihor, Iver] = extractEdges(ImagesIn(:,1:18), B1, B2); % edges of 1st original image
testEdgeExtraction(ImagesIn(:,1:18), Edges, Ihor, Iver) 
end


function [Edges, Ihor, Iver] = extractEdges(Iin, B1, B2)
Ihor = conv2(Iin, B2); % Image containing Horizontal gradients
Iver = conv2(Iin, B1);
%Edges = sqrt((Iver.^2) + (Ihor.^2)); % Combined edge image
Edges = imfuse(Ihor, Iver, 'montage');
end

function testEdgeExtraction(img, Edges, Ihor, Iver)
% Edge extractions are doubles - imagesc()
subplot(1,4,1), title('Original'), imshow(img);
subplot(1,4,2), title('Horizontal'), imshow(Ihor);
subplot(1,4,3), title('Verticle'), imshow(Iver);
subplot(1,4,4), title('Edges'), imshow(Edges);
end