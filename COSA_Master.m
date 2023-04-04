%% Chopstick Operation Skill Assessment using Computer Vision (COSA-CV)
clear all;
close all;

addpath('sources')

%% Rename & organize files 
% You can do this manually, but it will take lots of time if you have ~80
% files per camera. So it is highly recommended using this function to
% organize your video files.

rename_files('HY18', dirL, dirR, 2)

%% 2. Calibrate the Stereocamera

COSA_CV_Calib('HY18');

%% 3. Object Tracking
COSA_CV_object_tracking('HY18',2,2,1);

%% Triangulation
COSA_CV_triangulation('HY18',1,1);

%% Kinematic analysis
% You may use the loop to save all participants' data in one place.
for id=1:length(PID)
    [vel_save2, combined_data] = COSA_CV_kinematic_analysis('HY18','motor task success',id);
end
