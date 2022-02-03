function prediction = NNTesting(ImageTest, modelNN)
    
    dataset = modelNN.neighbours; % get trainImages
    
    % Obtaining EuclindeanDistance for each TrainImage and TestImage
    for i=1:size(dataset,1) 
        distance(i) = EuclideanDistance(ImageTest, modelNN.neighbours(i));
    end
    
    minValue = min(distance) % get min distance
    [val, idx] = min(abs(distance-minValue)) % get closest trainImage with this value (i.e. k = 1)
    prediction = modelNN.labels(idx) % get the label of the closest trainImage
    
end