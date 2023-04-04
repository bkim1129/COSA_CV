## Chopstick Operation Skill Assessment using Computer Vision (COSA-CV)

This MATLAB code provides instructions to assess the skill level of chopstick operation using computer vision. The assessment can be used to evaluate fine hand motor skills in healthy individuals and those with neurologic disorders, such as stroke, that affect fine hand motor skills.

## Sample Video Data Download
[Click here to download sample video files from Google Drive](https://drive.google.com/drive/folders/1Fr_mPyVMsOllc9yXrQ_YJ18UNFs_qJDo?usp=sharing)

## COSA Matlab codes
This folder contains all the codes and functions required to run the data processing.

# COSA_master
This code contains all the functions required to process the data, with comments in a specific order. You can open this code and run it line by line.

# rename_files
This function can be used to rename and organize video files. We highly recommend using this function if you have a large number of files. While you can organize the files manually, it will take a lot of time and can introduce human errors in the process.

# COSA_CV_Calib
This function calibrates the stereo camera and creates a MAT file containing the calibration parameters.

# COSA_CV_object_tracking
This function tracks objects in the video footage based on their color. We 3D printed the object using blue PLA filament, which worked best for us, but this may differ based on the lighting settings of your lab. We recommend using white LED lights as the light source.

# COSA_CV_triangulation
This function performs triangulation to obtain 3D coordinates of tracked objects.

# COSA_CV_kinematic_analysis
This function calculates and saves the kinematic data of all participants in one place. You can use a loop to analyze the kinematics of the participants' chopstick operation skill.

