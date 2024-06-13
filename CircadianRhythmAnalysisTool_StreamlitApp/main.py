import streamlit as st
import subprocess
import pandas as pd
import os
import io
import tempfile

# Specify the full path to Rscript if not in PATH
RSCRIPT_PATH = "C:\\Program Files\\R\\R-4.2.2\\bin\\Rscript.exe"  # Change to your Rscript path

def run_r_script(input_file, output_file):
    result = subprocess.run([RSCRIPT_PATH, 'run_NOSA.R', input_file, output_file], capture_output=True, text=True)
    return result

def main():
    st.title("Circadian Rhythm Analysis Tool")

    st.write("The Circadian Rhythm Analysis Tool is a user-friendly application designed to process and analyze data from Forced Desynchrony (FD) protocols. This tool is based on the Non-Stationary Oscillation Analysis (NOSA) method, enabling researchers to accurately estimate intrinsic circadian periods and separate the contributions of circadian rhythms from evoked components in physiology and behavior.")
   
    uploaded_files = st.file_uploader("Choose CSV files", type="csv", accept_multiple_files=True)
    
    if uploaded_files:
        results = []
        for uploaded_file in uploaded_files:
            input_data = uploaded_file.getvalue().decode("utf-8")
            input_df = pd.read_csv(io.StringIO(input_data))
            
            # Use temporary files for input and output
            with tempfile.NamedTemporaryFile(delete=False, suffix=".csv") as temp_input_file:
                input_path = temp_input_file.name
                input_df.to_csv(input_path, index=False)
                
            with tempfile.NamedTemporaryFile(delete=False, suffix=".csv") as temp_output_file:
                output_path = temp_output_file.name

            # Run the R script
            result = run_r_script(input_path, output_path)
            
            if result.returncode == 0:
                st.write(f"R script executed successfully for {uploaded_file.name}.")
                st.write(result.stdout)
                
                # Read the output data
                output_data = pd.read_csv(output_path)
                results.append(output_data)
            else:
                st.write(f"Error executing R script for {uploaded_file.name}.")
                st.write(result.stderr)

            # Clean up temporary files
            os.remove(input_path)
            os.remove(output_path)

        if results:
            combined_output = pd.concat(results, ignore_index=True)
            combined_output.columns = ["SUBJECT", "tau_value"]  # Rename columns

            st.write(combined_output)

            # Convert the combined output to CSV
            csv_buffer = io.StringIO()
            combined_output.to_csv(csv_buffer, index=False)
            csv_bytes = csv_buffer.getvalue().encode('utf-8')

            st.download_button(
                label="Download combined output as CSV",
                data=csv_bytes,
                file_name="combined_output.csv",
                mime="text/csv"
            )

if __name__ == "__main__":
    main()
