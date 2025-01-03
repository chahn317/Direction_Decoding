# Direction Decoding
Runs LSTM and decodes tongue marker direction from neural data (M1 and S1). Data is not included.

Code in Neural_Decoding folder (for binning, LSTM, and calculating R2) provided by the Kording Lab.

### How to Use:
1. Open direction_format.m with MATLAB and modify any user params. Running this file outputs formatted .mat structs stored in the Directions_Formatted folder.
2. Open Direction_Preprocessing.ipynb and modify any user params. Running this file outputs binned spikes/directions stored in the Directions_Binned folder.
3. Open Direction_Decoding.ipynb and modify any user params. Running this takes a while (approx 30 min on my local computer when bins_before/bins_before = 10, took about 5 min when bins_before/bins_before = 5), then the program prints out R2 for each dataset.