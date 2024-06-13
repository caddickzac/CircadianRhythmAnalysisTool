# run_NOSA.R

args <- commandArgs(trailingOnly = TRUE)
input_file <- args[1]
output_file <- args[2]

source("NOSA_function.R")

# Load the input data
data <- read.csv(input_file)

# Run the NOSA function
result <- NOSA(
  filename = input_file,
  subj_header = "SUBJECT",
  outcome = "MEL",
  num_harmonics = 8,
  t_cycle = 28,
  dec_point = 3
)

# Extract the result (tau_est1)
tau_est1 <- result[[1]]

# Get subject name
subject <- unique(data$SUBJECT)

# Create a data frame with subject and tau value
output_df <- data.frame(SUBJECT = subject, tau = tau_est1)

# Write the result to the output file
write.csv(output_df, output_file, row.names = FALSE)
