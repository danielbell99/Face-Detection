function nmsBoxes = nonMaximaSuspression(boundingBoxes, threshold)
   
    windowWidth = 18;
	windowHeight = 27;
	boundingBoxArea = windowWidth * windowHeight;
	
     %-- remove bounding boxes with confidence less than 0.7
    removeThis = [];
    for i=1:size(boundingBoxes(:,1))
        if boundingBoxes(i,5) < 0.7
            removeThis = [removeThis; i];
        end
    end
    boundingBoxes(removeThis, :) = [];
    
	% -- sort confidence scores from lowest to highest
	unsortedScores = boundingBoxes (:,end);
	[scores, indexes] = sort(unsortedScores);
    
	
    % define 2 boxes to be compared to eachother
    boundingBox1 = [0 0 18 27];
    boundingBox2 = [0 0 18 27];
    
    toKeep = []; % bounding boxes to keep
    
	while ~isempty(indexes)
        lastIdx = length(indexes);  % get last idx position
        i = indexes(lastIdx);       % get index with highest confidence score
        toKeep = [toKeep; i];       % and add it to array of picked indexs
        toDiscard = [lastIdx];
        for pos = 1:lastIdx-1
            % get next bounding box to compare to i
            j = indexes(pos);
			
            % define box i and j
            boundingBox1(1,1) = boundingBoxes(i,1);
            boundingBox1(1,2) = boundingBoxes(i,2);
            boundingBox2(1,1) = boundingBoxes(j,1);
            boundingBox2(1,2) = boundingBoxes(j,2);
			
            % calculate insection on box i and j
            intersectionArea = rectint(boundingBox1, boundingBox2);	
            
            % if area of overlap bigger than threshold
            if ((intersectionArea / boundingBoxArea) > threshold)
				toDiscard = [toDiscard; pos];	% add BB to array to be discarded
            end
        end
        
        % discard unwanted bounding boxes index's
        indexes(toDiscard) = [];
        
        % define bounding boxes to keep that we will return 
        for i = 1:length(toKeep)
            nmsBoxes(i, 1) = boundingBoxes(toKeep(i), 1);
            nmsBoxes(i, 2) = boundingBoxes(toKeep(i), 2);
            nmsBoxes(i, 3) = boundingBoxes(toKeep(i), 3);
            nmsBoxes(i, 4) = boundingBoxes(toKeep(i), 4);
        end
end
