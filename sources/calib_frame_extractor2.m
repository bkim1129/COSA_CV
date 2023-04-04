%% Save video frames to jpg files from the calibration MP4 video files.

% Set the name of the left video file to calib_Lt_files
calib_Lt_files = filename1;

% Read the left video file using VideoReader
videoObject = VideoReader(calib_Lt_files);

% Get the total number of frames in the video
numberOfFrames = videoObject.NumberOfFrame;

% Create a new directory to save the frames of the left video
mkdir(fname1(1:end-4));

% Set the step size for extracting frames from the video
step=1;

% Find the step size such that the total number of frames extracted is less than or equal to 100
while length(1:step:numberOfFrames)>100
    step=step +1;
end

% Initialize a counter variable to keep track of the frames saved
pp=1;

% Extract frames from the left video and save them as jpg files
for k=1+vid1_startFrame_add:step:numberOfFrames
    
    % Set the name of the output file to include the directory and a frame number
    save_file_name = [fname1(1:end-4),'_', num2str(pp)];
    
    % Create the full file path by appending the output directory to the output file name
    save_Lt_name=fullfile(fname1(1:end-4),save_file_name);
    
    % Read the current frame from the video
    thisFrame=read(videoObject,k);
    
    % Save the current frame as a jpg file
    imwrite(thisFrame,[save_Lt_name, '.jpg']);
    
    % Increment the frame counter
    pp=pp+1;
    
end

% Set the name of the right video file to calib_Rt_files
calib_Rt_files = filename2;

% Read the right video file using VideoReader
videoObject = VideoReader(calib_Rt_files);

% Create a new directory to save the frames of the right video
mkdir(fname2(1:end-4));

% Initialize a counter variable to keep track of the frames saved
pp=1;

% Extract frames from the right video and save them as jpg files
for k=1+vid2_startFrame_add:step:numberOfFrames
    
    % Set the name of the output file to include the directory and a frame number
    save_file_name = [fname2(1:end-4),'_', num2str(pp)];
    
    % Create the full file path by appending the output directory to the output file name
    save_Rt_name=fullfile(fname2(1:end-4),save_file_name);
    
    % Read the current frame from the video
    thisFrame=read(videoObject,k);
    
    % Save the current frame as a jpg file
    imwrite(thisFrame,[save_Rt_name, '.jpg']);
    
    % Increment the frame counter
    pp=pp+1;
    
end
