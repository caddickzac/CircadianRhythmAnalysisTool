# Circadian Rhythm Analysis Tool

The Circadian Rhythm Analysis Tool is a user-friendly application designed to process and analyze data from Forced Desynchrony (FD) protocols. This tool is based on the Non-Stationary Oscillation Analysis (NOSA) method, enabling researchers to accurately estimate intrinsic circadian periods and separate the contributions of circadian rhythms from evoked components in physiology and behavior.

## Table of Contents

- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [Input Data Format](#input-data-format)
- [Output Data Format](#output-data-format)
- [Dependencies](#dependencies)
- [Create a batch file to run program instead of using command line](#Create-a-batch-file-to-run-program-instead-of-using-command-line)
## Features

- Upload multiple CSV files for analysis.
- Estimate intrinsic circadian periods.
- Separate circadian rhythms from evoked components.
- Download the processed results as a CSV file.

## Installation

### Prerequisites

- [Python 3.9+](https://www.python.org/downloads/)
- [R 4.1.2+](https://cran.r-project.org/mirrors.html)

### Steps

1. **Clone the repository:**

    ```sh
    git clone https://github.com/your-username/circadian-rhythm-analysis-tool.git
    cd circadian-rhythm-analysis-tool
    ```

2. **Install Python dependencies:**

    ```sh
    pip install -r requirements.txt
    ```

3. **Ensure R is installed and the required packages are available:**

    Open R and run:

    ```r
    install.packages(c('here', 'readr', 'dplyr', 'tidyr', 'lubridate', 'numbers', 'Matrix', 'nlme'), repos='http://cran.us.r-project.org')
    ```

4. **Update local R install location:**

   Edit "main.py" line 9
   ```RSCRIPT_PATH = "C:\\Program Files\\R\\R-4.2.2\\bin\\Rscript.exe" # Change to your Rscript path ```


## Usage

1. **Run the Streamlit application:**

    ```sh
    streamlit run main.py
    ```

2. **Upload CSV files:**

    Use the file uploader to select one or multiple CSV files containing your data.

3. **Download the results:**

    After processing, you can download the results as a CSV file.

## Input Data Format

Each CSV file should contain the following columns:

- `SUBJECT`: Identifier for the subject.
- `Labtime`: Laboratory time.
- `MEL`: Melatonin levels.
- `elapsed_time_hrs`: Elapsed time in hours.

Example:

```csv
SUBJECT,Labtime,MEL,elapsed_time_hrs
A0001,5754.53,0.95,0.00
A0001,5755.52,0.97,0.98
A0001,5756.53,7.96,2.00
A0001,5757.57,25.48,3.03
A0001,5758.53,44.69,4.00
```

## Output Data Format
The output CSV file will contain two columns:

SUBJECT: Identifier for the subject.
Tau: Estimated intrinsic circadian period.
Example:

```csv
SUBJECT,Tau
A0001,24.15
```

## Dependencies
Python 3.9+
R 4.1.2+
Python packages: streamlit, pandas
R packages: here, readr, dplyr, tidyr, lubridate, numbers, Matrix, nlme


## Create a batch file to run program instead of using command line
1. Create text document on desktop
2. Enter code below, changing "[working directory]" to your local directory where the streamlit app is saved. 

```bash
@echo off
REM set working directory
cd [working directory]

REM Activate the virtual environment
call venv/Scripts/activate

REM Run the Streamlit app using the Python installation in the virtual environment
streamlit run main.py

REM Pause command to keep the terminal open after the script runs (optional)
pause
```
3. Save and close text document.
4. Change file type from ".txt" to ".bat"
5. Now you can run the batch file as a shortcut icon and avoid having to enter any code in the command line!
