# Chopstick Operation Skill Assessment using Computer Vision (COSA-CV)

This MATLAB code provides instructions to assess the skill level of chopstick operation using computer vision. The assessment can be used to evaluate fine hand motor skills in healthy individuals and those with neurologic disorders, such as stroke, that affect fine hand motor skills.

## Accuracy of the system
We conducted experiments to evaluate the accuracy of our computer vision-based motion analysis system, and the findings were published in the Scientific Reports.
Citation: Kim, B., Neville, C. Accuracy and feasibility of a novel fine hand motor skill assessment using computer vision object tracking. Sci Rep 13, 1813 (2023). https://doi.org/10.1038/s41598-023-29091-0

[Click here to the Scientific Reports paper](https://www.nature.com/articles/s41598-023-29091-0)


# Sample Video Data Download
[Click here to download sample video files from Google Drive](https://drive.google.com/drive/folders/1Fr_mPyVMsOllc9yXrQ_YJ18UNFs_qJDo?usp=sharing)

## Time points in the sample data
1. Baseline (10 trials)
2. Practice block 1 (5 trials)
3. Practice block 2 (5 trials)
4. Practice block 3 (5 trials)
5. Practice block 4 (5 trials)
6. Practice block 5 (5 trials)
7. Practice block 6 (5 trials)
8. Practice block 7 (5 trials)
9. Practice block 8 (5 trials)
10. Practice block 9 (5 trials)
11. Practice block 10 (5 trials)
12. Immediate Post-practice retention (10 trials)
13. 24-h Delayed Post-practice retention (10 trials)

## File nameing:
- HY15_Lt_base1.mp4: Participant ID was HY15, the camera location was left, the timepoint was baseline, & it was first trial of the baseline timepoint.
- HY15_Lt_calib.mp4: This video footage is for the calibration.
- motor task success.xlsx is for kinematic analysis. You need this file to choose the successful trials.


# COSA Matlab codes
This folder contains all the codes and functions required to run the data processing.

## COSA_master
This code contains all the functions required to process the data, with comments in a specific order. You can open this code and run it line by line.

## rename_files
This function can be used to rename and organize video files. We highly recommend using this function if you have a large number of files. While you can organize the files manually, it will take a lot of time and can introduce human errors in the process.

## COSA_CV_Calib
This function calibrates the stereo camera and creates a MAT file containing the calibration parameters.

## COSA_CV_object_tracking
This function tracks objects in the video footage based on their color. We 3D printed the object using blue PLA filament, which worked best for us, but this may differ based on the lighting settings of your lab. We recommend using white LED lights as the light source.

## COSA_CV_triangulation
This function performs triangulation to obtain 3D coordinates of tracked objects.

## COSA_CV_kinematic_analysis
This function calculates and saves the kinematic data of all participants in one place. You can use a loop to analyze the kinematics of the participants' chopstick operation skill.
