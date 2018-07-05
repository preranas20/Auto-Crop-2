# Auto-Crop-2
Matlab Algorithm to automatically crop a document from an image in the most optimized way. The corner coordinates of the document obtained are matched with the groung truth which is already given. For each image: 
  - if the intersection over union between the returned bounding box and the ground truth is at least 80%, 2 points are given for the image
  - if the intersection over union is at least 50%, 1 point is given for the image.
  
Total score is calculated and increased as much possible by optimizing the algorithm(in **auto_crop.m**).

## Asumptions Made:

- Documents are mostly bright in color (e.g. white).
- The center of the image is always part of the document.
- The entire document is captured and the border of the image will be background pixels.
- The document will be rectangular with minimal shearing.
- The text could be rotated up to +/- 60 deg.

## Concepts used:
- Gaussian filtering
- Threshold
- Canny Edge Detection
- Hough Transform

