%% Video Sync using Audio
% this code synchronize two video files using the audio data from the video
% files.

% Read the audio data and sampling rate from the first video file
[y1,fs1]=audioread(filename1);


% Read the audio data and sampling rate from the second video file
[y2,fs2]=audioread(filename2);

% Take the mean of the stereo audio signals from both files
y1=mean(y1,2);
y2=mean(y2,2);

% Calculate the cross-correlation between the audio signals from the two videos
[c,lags]=xcorr(y1,y2);

% Find the index of the maximum absolute value of the cross-correlation coefficients
[~,idx]=max(abs(c));

% Read the video files using VideoReader
videoObject1=VideoReader(filename1);
videoObject2=VideoReader(filename2);

% Determine the time delay between the two videos using the synchronization index
lag_idx=lags(idx);
sync_idx=round(lag_idx/fs1*videoObject1.FrameRate);



% Determine the start frames of both videos depending on the synchronization index
if sync_idx ==0
    vid1_startFrame_add = 0;
    vid2_startFrame_add = 0;
elseif sync_idx <0
    vid1_startFrame_add = 0;
    vid2_startFrame_add = abs(sync_idx);
elseif sync_idx >0
    vid1_startFrame_add = abs(sync_idx);
    vid2_startFrame_add = 0;
end