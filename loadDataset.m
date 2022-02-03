function [images labels] = loadDataset(filename, sampling)

if nargin<2
    sampling = 1;
end

fp = fopen(filename, 'rb');
assert(fp ~= -1, ['Could not open ', filename, '']);

line1=fgetl(fp);
line2=fgetl(fp);

numberOfImages = fscanf(fp,'%d',1);

images=[];
labels =[];
for im=1:sampling:numberOfImages
    
    label = fscanf(fp,'%d',1);
    labels= [labels; label];
    
    imfile = fscanf(fp,'%s',1);
    I=imread(imfile);
    
    % convert to greyscale
    if size(I,3)>1
        I=rgb2gray(I);
    end
    
    vector = reshape(I,[1, size(I, 1) * size(I, 2)]);
    vector = double(vector);

    images = [images; vector];
    
    % mirror the images so we have more images to train our model
    mirrored = flip(I,2);
    vector = reshape(mirrored, 1, size(I, 1) * size(I, 2));
    vector = double(vector);
    images = [images; vector];
    labels = [labels; label];
           
   
end

fclose(fp);

end