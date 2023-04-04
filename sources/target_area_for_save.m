%% Assign the area of search for the object. This step can be skipped if you are using the same workspace.

% Set the filename for the left camera
fullFileName = left_filename;

% Set the camera number for the left camera
cam=1;

% Create a VideoReader object for the left camera video file
videoObject = VideoReader(fullFileName);

% Read the first frame of the left camera video
thisFrame = read(videoObject,1);

% If the current camera is the left camera, undistort the image using the 
% camera parameters for the left camera. If it's the right camera, use the
% camera parameters for the right camera.
if cam==1
    thisFrame = undistortImage(thisFrame,stereoParams.CameraParameters1);
elseif cam==2
    thisFrame = undistortImage(thisFrame,stereoParams.CameraParameters2);
end

% Display the current frame in a figure window and ask the user to select
% the area of the object to be tracked.
imshow(thisFrame);
title('Select search target')
target_area_save_Lt = round(getrect(figure(1)));


% Set the filename for the right camera
fullFileName = right_filename;

% Set the camera number for the right camera
cam=2;

% Create a VideoReader object for the right camera video file
videoObject = VideoReader(fullFileName);

% Read the first frame of the right camera video
thisFrame = read(videoObject,1);

% If the current camera is the left camera, undistort the image using the 
% camera parameters for the left camera. If it's the right camera, use the
% camera parameters for the right camera.
if cam==1
    thisFrame = undistortImage(thisFrame,stereoParams.CameraParameters1);
elseif cam==2
    thisFrame = undistortImage(thisFrame,stereoParams.CameraParameters2);
end

% Display the current frame in a figure window and ask the user to select
% the area of the object to be tracked.
imshow(thisFrame);
title('Select search target')
target_area_save_Rt = round(getrect(figure(1)));

% Save the selected target areas to a MAT file for later use
save('target_save.mat','target_area_save_Lt','target_area_save_Rt')


