function COSA_CV_Calib(PID)
%% Computer vision based motion capture master script for calibration




%% Calibration frame extraction


% file names
fname1 = [PID,'_Lt_Calib.mp4'];
fname2 = [PID,'_Rt_Calib.mp4'];



filename1= fullfile(fname1);
filename2= fullfile(fname2);


% synchronize videos using the audio file
vid_sync_audio;

% extract calibration images from the video
calib_frame_extractor2;

% recall the images from their folders
folder1=fname1(1:end-4);
folder2=fname2(1:end-4);

dir1=dir(folder1);
dir2=dir(folder2);

% designate image file names to import
for kk=1:length(dir1)
    imgName1{kk}=fullfile(dir1(kk).folder,dir1(kk).name);
    
    imgName2{kk}=fullfile(dir2(kk).folder,dir2(kk).name);
    
end

% In the directory, first two names are not files. So delete these two
% names.
imgName1(1:2)=[];
imgName2(1:2)=[];

% run the calibration
stereo_camera_calibration_script;

% assign the calibration parameter data file name
calib_filename = [fname1(1:end-7),'2'];

% save the calibration parameter as a mat file
save(calib_filename,'stereoParams')

end