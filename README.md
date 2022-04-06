# Axon-density-analyzer-ImageJ-script
This is a custom-made ImageJ script for analyzing axon densities in fluorescent confocal images, 
written by Csaba Dávid (Institute of Experimental Medicine, Budapest, Hungary).

Please cite the following article if you use this script:

Mátyás F, Komlósi G, Babiczky Á, Kocsis K, Barthó P, Barsy B, Dávid C, Kanti V, Porrero C, Magyar A, Szűcs I, Clasca F, Acsády L. 
A highly collateralized thalamic cell type with arousal-predicting activity serves as a key hub for graded state transitions in the forebrain. 
Nat Neurosci. 2018 Nov;21(11):1551-1562. 
doi: 10.1038/s41593-018-0251-9. 
Epub 2018 Oct 22. 
PMID: 30349105; 
PMCID: PMC6441588.

***
Instructions

The script works with .tif files of confocal Z-stacks captured at high magnification (e.g. 63x). 
You should use images with good signal-to-noise ratios. Strong background noise can cause errors in the analysis. 
You can use ImageJ's built-in script (Process/Noise/Remove outliers...) to reduce noise.

1. Make sure that your .tif image filename doesn't have any special characters in it, especially "+" and "~".

2. Open your .tif image in ImageJ.

3. Run the 'skeletonizer.ijm' script in ImageJ with your .tif image file open. This script finds axons in your image based on a threshold level you set.

4. Follow the script's instructions: point to the folder where you unpacked kernels.rar* and create a new folder where you want to save your frames. 
You may have to take a few rounds figuring out the appropiate threshold levels and kernels for your images. 
You can analyze multiple channels in the same time with different thresholds and kernels. Let the script run. 

5. When finished, a log window pops up with the elapsed time. You now have separate .tif files for each channel in the previously defined folder. 
Check the these frame images and compare them to your original images. If they seem OK, you can proceed. 
Please note that out-of-focus or noisy planes might cause errors: you should remove such planes.

6. Close all windows in ImageJ.

7. Run 'ROI_drawer.ijm' in ImageJ. This script creates regions of interests (i.e. nuclei) where you want to measure axon densities in your images.

8. Follow the script's instructions. You can use your original .tif image to draw the necessary ROI area or use any other .tif image. 
Make sure that the images have the exact same name. Create a folder where the scripts save your ROIs. 
You can define various nuclei in one image or open new images.

9. After defining all the necessary nuclei in all images you can close the 'ROI_drawer.ijm' script.

10. Run 'measure_in_ROI.ijm' in ImageJ. This script measures the previously detected axons within the previously defined ROIs.

11. Point to the folder where you saved your frames (step 4.) then point to the folder where you saved your ROIs (step 8.). 
The script measures total axon length within each ROI in each image in each channel. 
It might take a while. When finished a Summary window will pop up with your results.

12. Save your results. You can close ImageJ or proceed to the next image.

Other notes:

You can measure your actual ROI areas in ImageJ if your original .tif file contains appropiate metadata. You might need ROI area size to calculate axon densities.

Never rename the files the scripts create. This might cause errors.

*Kernels are nxn matrices for image convolution. In our case these matrices are responsible for the direction sensitivity of the script. 
We defined a set of kernels, with different preferential angles. 
Pilot studies showed thet 6 different directions (0, 30, 60, 90, 120, 150 degree) is sufficient for detection of axons in any direction. 

You can create a kernel as a .txt file. Most of the values should be zeros, while values in a given direction should have a value greater then 0, e.g.:

0 0 10 0 0
0 0 20 0 0
0 0 30 0 0
0 0 20 0 0
0 0 10 0 0 

In this kernel the vertical (90 degree) direction will be detected. 

The following kernel detect the oblique lines at 30 degrees:

0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
1 2 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 0 3 4 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 5 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 6 7 0 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 8 9 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 10 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 9 8 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 7 6 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 5 4 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2 1 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 

The size of the kernel depends on the lines to be detected. If there are large linear pieces, the kernel can also be large, otherwise the smaller size is preferable. 
The heigher wiegths (values other than 0) give more salient results. 

***

If you have any further questions please contact dr. Ferenc Mátyás (Institute of Experimental Medicine, Budapest, Hungary) at 'matyasf@koki.hu', 
Csaba Dávid (Institute of Experimental Medicine, Budapest, Hungary) at david.csaba@koki.hu 
or Ákos Babiczky (Institute of Experimental Medicine, Budapest, Hungary) at babiczky.akos@koki.hu.
