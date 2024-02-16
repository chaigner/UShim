# UShim

This repository contains a MATLAB implementation to load channel-wise in vivo B1+ datasets of the human cervical and thoracolumbar spine at 7T and to compute and evaluate universal RF shims as described in [1]. The channel-wise in vivo B1+ datasets of the human body at 7T are available at: [https://doi.org/10.6084/m9.figshare.14778345.v2 ](https://doi.org/10.6084/m9.figshare.25233385.v1).


##### Authors:
- Christoph S. Aigner  (<christoph.aigner@ptb.de>)
- Sebastian Schmitter  (<sebastian.schmitter@ptb.de>)

Usage
--------

Run script main.m: This script takes the user through the universal shim pulse design and shim prediction


Contents
--------

##### Test scripts (run these):
    main.m          test script to compute and evaluate tailored and universal pulses at 7T

##### Routines called by the test scripts:
    TBD
    
##### External data files used by the test scripts:
    CSpine_data.mat      available at [https://doi.org/10.6084/m9.figshare.14778345.v2 ](https://doi.org/10.6084/m9.figshare.25233385.v1)
    TLSpine_data.mat     available at [https://doi.org/10.6084/m9.figshare.14778345.v2 ](https://doi.org/10.6084/m9.figshare.25233385.v1)
    
Dependencies
------------
These routines were tested under MATLAB R2019a under Windows, but should also run under older versions.

License
-------

This software is published under GNU GPLv3. 
In particular, all source code is provided "as is" without warranty of any kind, either expressed or implied. 
For details, see the attached LICENSE.

Reference
---------

[1] Aigner, Sanchez Alarcon, D'Astous, Alonso-Ortiz, Cohen-Adad and Schmitter. Calibration-Free Parallel Transmission of the Cervical, Thoracic, and Lumbar Spinal Cord at 7T. Submitted to MRM
Created by Christoph S. Aigner, PTB, Feb 2024.
Email: christoph.aigner@ptb.de
