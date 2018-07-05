# Auto-Crop-2
Matlab Algorithm to automatically crop a document from an image in the most optimized way. The corner coordinates of the document obtained are matched with the groung truth which is already given.

##Asumptions Made:

- Documents are mostly bright in color (e.g. white).
- The center of the image is always part of the document.
- The entire document is captured and the border of the image will be background pixels.
- The document will be rectangular with minimal shearing.
- The text could be rotated up to $$\pm 60^{\circ}$$.
