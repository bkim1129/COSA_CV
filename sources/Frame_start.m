%% This code detects the auditory cue (whistle sound) in the video file.
% The auditory cue will be used as a starting frame of each video.

% Set the file names of the left and right videos
filename1=left_filename;
filename2=right_filename;

% Synchronize the audio and video files using the audio cue
vid_sync_audio;

% Set the file name for the left video
filename = left_filename;

% Detect the audio cue in the left video to determine the start frame
audio_cue_detect;

% Create a VideoReader object for the left video
videoObject = VideoReader(filename);

% Calculate the start frame for the right video based on the audio cue
v1_FrameStart=round(locs_cue_onset/fs*videoObject.FrameRate);
if sync_idx ==0
    v2_FrameStart=v1_FrameStart;
elseif sync_idx <0
    v2_FrameStart=v1_FrameStart + vid2_startFrame_add;
elseif sync_idx >0
    v2_FrameStart=v1_FrameStart - vid2_startFrame_add;
end






