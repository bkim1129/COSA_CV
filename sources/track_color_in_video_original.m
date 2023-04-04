%% This code track the object based on its color.

% Instantiate a video reader object for this video.
videoObject = VideoReader(fullFileName);

% Read the first frame of the video.
objectFrame = readFrame(videoObject);

% Depending on the camera used, select the target area for object tracking.
if cam==1
    target_area = target_area_save_Lt(1,:);
elseif cam==2
    target_area = target_area_save_Rt(1,:);
end

% Set up the total number of frames for video processing.
numberOfFrames = videoObject.NumberOfFrame;

% Set HSV thresholds for the green sharpie in the demo video.
% Modify the thresholds to detect different colors.

if color==1
    %% blue - main object that is manipulated.
    hThresholds = [0.35, 0.7];
    sThresholds = [0.5, 1];
    vThresholds = [100, 255];
elseif color==2
    %% Yellow - this is optional if you want to track the movement of the chopsticks.
    hThresholds = [0.13, 0.16];
    sThresholds = [0.9, 1];
    vThresholds = [100, 255];
end

%% Read one frame at a time from the input video, and find the object based on the specified color.

% setup the total number of frames to read.
if color==1
    kk= sf+600; % this is for the main target object.
elseif color==2
    kk= sf+50; % this is for the chopstick to detect when the hand starts moving.
end

for k = sf:kk
    % Read one frame.
    thisFrame=read(videoObject,k);
    
    % Undistort the frame.
    if cam==1
        thisFrame = undistortImage(thisFrame,stereoParams.CameraParameters1);
    elseif cam==2
        thisFrame = undistortImage(thisFrame,stereoParams.CameraParameters2);
    end
    
    % Convert the current frame to HSV color space.
    hsv = rgb2hsv(double(thisFrame));
    
    % Set pixels outside the target area to 0 in each channel of the HSV
    % color space image.
    hsv(:,1:target_area(1),:)=0;
    hsv(:,target_area(1)+target_area(3):end,:)=0;
    hsv(1:target_area(2),:,:)=0;
    hsv(target_area(2)+target_area(4):end,:,:)=0;
    
    % Extract hue, saturation, and value channels from the HSV color space
    % image.
    hue=hsv(:,:,1);
    sat=hsv(:,:,2);
    val=hsv(:,:,3);
    
    % The code between the lines that start with "%%" are commented
    % out. If you uncomment them, they will display the image and
    % draw rectangles around the objects found, and text with the
    % coordinates of the center of each object. This will slow down the
    % object detection process.
    %% -------------------------------------------------------------
    % if k == sf
    % 		% Enlarge figure to full screen.
    % 		set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
    % 		% Give a name to the title bar.
    % 		set(gcf, 'Name', 'Demo by ImageAnalyst', 'NumberTitle', 'Off')
    % 		hCheckbox = uicontrol('Style','checkbox',...
    % 			'Units', 'Normalized',...
    % 			'String', 'Finish Now',...
    % 			'Value',0,'Position', [.2 .96 .4 .05], ...
    % 			'FontSize', 14);
    % end
    %% -------------------------------------------------------------
    
    % Create binary masks for each channel based on the specified color
    % thresholds.
    binaryH = hue >= hThresholds(1) & hue <= hThresholds(2);
    binaryS = sat >= sThresholds(1) & sat <= sThresholds(2);
    binaryV = val >= vThresholds(1) & val <= vThresholds(2);
    
    % Combine the binary masks for the three channels into a single binary
    % mask for the specified color.
    coloredMask = binaryH & binaryS & binaryV;
    
    % Filter out small blobs.
    coloredMask = bwareaopen(coloredMask, 100);
    
    % Fill holes
    coloredMask = imfill(coloredMask, 'holes');
    
    % Perform a morphological close operation on the image
    se=strel('square',10);
    coloredMask=imclose(coloredMask,se);
    
    % bwlabel labels connected components in a binary image and returns
    % labeledImage, an array where pixels belonging to the same object have the same
    % integer value. numberOfRegions is the number of distinct objects found.
    [labeledImage, numberOfRegions] = bwlabel(coloredMask);
    
    if numberOfRegions >= 1
        % regionprops measures a set of properties for each labeled region
        % in labeledImage. 'BoundingBox' and 'Centroid' are two of the
        % properties that are measured.
        stats = regionprops(labeledImage, 'BoundingBox', 'Centroid');
        
        % Delete old texts and rectangles from previous frames.
        if exist('hRect', 'var')
            delete(hRect);
        end
        if exist('hText', 'var')
            delete(hText);
        end
        
        % The code between the lines that start with "%%" are commented
        % out. If you uncomment them, they will display the image and
        % draw rectangles around the objects found, and text with the
        % coordinates of the center of each object. This will slow down the
        % object detection process.
        % ---------------------------------
        % 		imshow(thisFrame);
        % 		axis on;
        % 		hold on;
        % 		caption = sprintf('%d blobs found in frame #%d 0f %d', numberOfRegions, k, numberOfFrames);
        % 		title(caption, 'FontSize', fontSize);
        % 		drawnow;
        % ---------------------------------
        
        r=1;
        
        % Find the bounding box for this object.
        thisBB = stats(r).BoundingBox;
        
        % If there are 2 or 3 objects, the centroids will be averaged.
        if numberOfRegions ==2
            thisCentroid1 =stats(1).Centroid;
            thisCentroid2 =stats(2).Centroid;
            thisCentroid(1)=mean([thisCentroid1(1) thisCentroid2(1)]);
            thisCentroid(2)=mean([thisCentroid1(2) thisCentroid2(2)]);
        elseif numberOfRegions ==3
            thisCentroid1 =stats(1).Centroid;
            thisCentroid2 =stats(2).Centroid;
            thisCentroid3 =stats(3).Centroid;
            thisCentroid(1)=mean([thisCentroid1(1) thisCentroid2(1) thisCentroid3(1)]);
            thisCentroid(2)=mean([thisCentroid1(2) thisCentroid2(2) thisCentroid3(2)]);
        else
            thisCentroid = stats(r).Centroid;
        end
        
        % Save the centroid of the object.
        centroid_save(k,:)=thisCentroid;
        
        % The code between the lines that start with "%%" are commented
        % out. If you uncomment them, they will display the image and
        % draw rectangles around the objects found, and text with the
        % coordinates of the center of each object.
        % -----------------------------------------
        % 			rectangle('Position', thisBB, 'EdgeColor', 'r', 'LineWidth', 2);
        % 			plot(thisCentroid(1), thisCentroid(2), 'y+', 'MarkerSize', 10, 'LineWidth', 2)
        % 			hText = text(thisBB(1), thisBB(2)-20, strcat('X: ', num2str(round(thisCentroid(1))), '    Y: ', num2str(round(thisCentroid(2)))));
        % 			set(hText, 'FontName', 'Arial', 'FontWeight', 'bold', 'FontSize', 12, 'Color', 'yellow');
        % % 		end
        % 		hold off
        % 		drawnow;
        % -----------------------------------------
        
        
    end
    
end

% setup the output MAT file name
if color==1
    outputfullFileName = [fullFileName,'.mat'];
elseif color==2
    outputfullFileName = [fullFileName,'_chopstick.mat'];
end

% Save the centroid coordinates as a MAT file.
save(outputfullFileName, 'centroid_save');


