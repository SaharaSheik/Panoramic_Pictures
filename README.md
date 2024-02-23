# Panoramic_Pictures
Creating Panoramic Image Mosaics 

# Introduction
This report outlines the process and methods employed in creating image mosaics as part of the assignment. The task involved synthesizing sequences, drawing from both provided examples and personal selections. The creation of image mosaics typically involves a series of steps:

## Feature Detection: 
Identifying distinctive features within each image, commonly accomplished using techniques like SIFT or SURF to pinpoint keypoints.
## Feature Matching: 
Establishing corresponding features across pairs of adjacent images in the sequence.
## Homography Estimation: 
Estimating the transformation (homography) between matched feature points, often employing methods like RANSAC to ensure robustness against outliers.
## Image Warping: 
Adjusting each image based on the estimated homography to achieve alignment.
## Image Blending: 
Seamlessly integrating the warped images through techniques such as alpha blending.
## Panorama Composition: 
Combining all images to form the final panoramic image.
# Methods
In creating mosaics for each sequence (MyPics1, Mov2, Mov3, and Mypics2), the aforementioned steps were meticulously followed. The organization of images within the sequence was crucial to facilitate seamless panoramic creation.

For feature point correspondence, SIFT from the SIFT toolbox was utilized, allowing for automated point correspondence tracking. To ensure robust homography estimation, Peter's MATLAB functions, incorporating a RANSAC homography function, were employed.

The SIFT algorithm utilized eliminated the need for specifying the number of points to select, deviating from initial assignment instructions. Additionally, the RANSAC homography fitting algorithm facilitated threshold adjustment, with the threshold ranging from 0.001 to 0.1. A higher threshold compromised precision in the final result.

Utilizing the computed homography, subsequent images were warped and seamlessly integrated using MathWorks code capable of stitching two images together. This iterative process continued until all images were registered and warped.

# Challenges Encountered
Several challenges were encountered during the project:

## Memory Constraints: 
Processing high-quality images led to memory limitations in MATLAB. To mitigate this issue, image resizing was employed to optimize code functionality.
## Handling Uniform Backgrounds: 
Sequences featuring images with uniform backgrounds posed difficulties during warping. Consequently, images with very uniform backgrounds were excluded.
## Error with Large Image Sequences: 
The use of numerous images resulted in errors, necessitating a reduction in the number of images utilized. For instance, 'Mypic1' was limited to five images to circumvent this issue.

# Conclusion

As detailed in the methodology section, the extent of overlap among images within the sequence emerges as a critical determinant of the quality of panoramic image outputs. Initial attempts encountered challenges stemming from inadequate overlap percentages between images, leading to suboptimal results. However, upon careful analysis of the images provided via webcourses, proactive adjustments were made to increase the overlap percentage. This proactive approach effectively addressed the challenges previously encountered, resulting in improved panoramic image quality.

# References:

MATLAB Documentation: Feature-Based Panoramic Image Stitching. Available at: https://kr.mathworks.com/help/vision/examples/feature-based-panoramic-image-stitching.html

MATLAB Documentation: affine2d.issimilarity. Available at: https://www.mathworks.com/help/images/ref/affine2d.issimilarity.html

MATLAB Documentation: Feature-Based Panoramic Image Stitching. Available at: https://kr.mathworks.com/help/vision/examples/feature-based-panoramic-image-stitching.html



