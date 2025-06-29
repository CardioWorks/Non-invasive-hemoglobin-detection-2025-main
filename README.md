This repository is organized into several main modules, each responsible for a key part of the non-invasive hemoglobin detection workflow. It operates on MATLAB R2023a (MathWorks Inc) and PyCharm (Python 3.10) platforms.


1. FEATURE
This module focuses on feature extraction from PPG signals, including complex network mapping and morphological features.

"Complex network mapping"
Contains Python scripts (function.py, main.py, ReadFile.py) and subfolders for complex network analysis.

Subfolders:
"Complex network": Contains network analysis code.
"DATA": Input data for feature extraction.
"OUTPUT": Results and outputs from feature extraction.

"Morphological feature extraction"
Contains MATLAB code (main.m) and subfolders for extracting morphological features.

Subfolders:
"CODE": MATLAB scripts for feature extraction.
"DATA": Input data.
"OUTPUT": Output results.

2. FILTER
This module focuses PPG signal preprocessing and statistical feature calculation.

"CODE": MATLAB scripts for signal processing.
"DATA": Input signals
"OUTPUT": Processed results.

3. MODEL
This module contains machine learning models for classification and regression tasks. It was divided into different experimental trails.

4. RESULT
This module contains results of different experimental trails.

First uploaded date: June 26, 2025
