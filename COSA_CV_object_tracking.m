function COSA_CV_object_tracking(PID,time_point_start,time_point_end,color_code)
%% This code runs the object detection.
% 'PID' is the participant's ID.
% 'time_point_start' is the first time point to run the object detection.
% 'time_point_end' is the last time point to run the object detection. Max
% would be 13.
% If you only want to run the process for a specific time point, you put
% the number of time point for both start and end.
% 'color_code' is the color of the object. Input 1 for the blue object.

%% Setup color thresholds
gThresholds=[80 200];
rThresholds=[70 180];
bThresholds=[0 100];
color=color_code;

%% Other Settings
format long g;
format compact;
fontSize = 20;
timepoints={'base', 'p1_', 'p2_', 'p3_', 'p4_', 'p5_', 'p6_', 'p7_', 'p8_', 'p9_', 'p10_', 'IR', 'DR'};



%% Loop over all videos

for ii=time_point_start:time_point_end
    if ii>=2 && ii<=11
        utnum=5;
    else
        utnum=10;
    end
    for i=1:utnum
        
        %% Load stereo parameters
        if ii<=12
            calib_left_filename = 'HY18_Lt_Ca2.mat';
        else
            calib_left_filename = 'HY18_Lt_Ca2.mat';
        end
        
        load(calib_left_filename);
        
        %% Setup video file names
        fname1 = [PID,'_Lt_',timepoints{ii},num2str(i),'.mp4'];
        fname2 = [PID,'_Rt_',timepoints{ii},num2str(i),'.mp4'];
        
        left_filename = fullfile(fname1); % if the files are in the folder, need to use this line.
        right_filename = fullfile(fname2); % if the files are in the folder, need to use this line.
        
        %% Setup & Load target area for current video
        if i==1 && ii==1
            target_area_for_save
        else
            load('target_save.mat');
        end
        
        %% Detect the auditory cue and synchronize two videos.
        Frame_start;
        
        close all
        
        %% Process Left camera video
        fullFileName = left_filename; % file name
        sf = v1_FrameStart; % starting frame number
        cam=1; % camera number (1=left)
        tic % timer on
        track_color_in_video_original % object tracking
        eTimeL(ii,i)=toc; % timer off
        
        clear centroid_save
        
        %% Process Right camera video
        fullFileName = right_filename; % file name
        sf = v2_FrameStart; % starting frame number
        cam=2; % camera number (2=right)
        tic % timer on
        track_color_in_video_original % object tracking
        eTimeR(ii,i)=toc; % timer off
        
        close all
        i % display the trial number
    end
    ii % display the time point
end



% Define output file name
output_file1 = strcat(left_filename(1:end-4), '.csv');
output_file2 = strcat(right_filename(1:end-4), '.csv');

% Save eTimeR to CSV file
writematrix(eTimeR,output_file1)
writematrix(eTimeL,output_file2)
end