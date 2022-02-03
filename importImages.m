% IMPORT IMAGES

function [images] = importImages(subdir, ext, startnum, endnum)
% Captures and returns intended filenames and images
% subdir - folder name for type of images of interest
% ext - file extension (eg. '.jpg', '.png')
% startnum & endnum - range of images (1-indexed)

parentfolder = 'I:/csc3067-2021-g32/images/'; % static parent folder
folder = strcat(parentfolder, subdir);

images = []; % images stored as concatenation of matrices
if exist(folder) % if subdir actually exists
    for i = startnum:endnum
        filename = sprintf(strcat('%d', ext), i); % converts to character vector
        fullFilename = fullfile(folder, filename);
        if exist(fullFilename, 'file')
            img = imread(fullFilename); % captured image
            images = [images, img]; % append to array for return
            %imshow(img);
        else
            Error = strcat(filename,' does not exist') % doesn't halt import
        end
    end
else
    warningMessage = sprintf('Error: Folder not found\n%s', sprintf(folder));
    uiwait(warndlg(warningMessage));
end