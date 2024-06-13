library('here')
library('readr')
library('dplyr')
library('tidyr')
library('lubridate')
library('numbers')
library('Matrix')
library('nlme')

xVal <- function(num_harmonics, cycle_length, time_values) {
  harmonics <- matrix(0, nrow=length(time_values), ncol=num_harmonics*2)
  for (i in 1:num_harmonics) {
    harmonics[, (2*i-1)] <- sin(2 * pi * i * time_values / cycle_length)
    harmonics[, (2*i)] <- cos(2 * pi * i * time_values / cycle_length)
  }
  return(harmonics)
}


NOSA <-
    function(filename,
             subj_header,
             outcome,
             num_harmonics = 8,
             t_cycle = 28,
             dec_point = 2) {
        #-----------------------------------------------
        ## SETTING UP THE DATA
        #copying the data
        df <- readr::read_csv(filename,show_col_types = FALSE)
        #attach(df)

        # extracting the outcome from the data
        NOSA_outcome <- dplyr::pull(df, var = outcome)

        #Calculating the t1 values for each row
        time2 <-
            df$elapsed_time_hrs - floor(df$elapsed_time_hrs / t_cycle) * t_cycle

        #Evoked Signal (number of harmonics, must be specified by user)
        evok_metrics <- xVal(num_harmonics, t_cycle, time2)

        #number of amplitudes that will be calculated
        amp <- rep(0, num_harmonics + 2)

        #-------------------------------------------------
        ## FOR LOOP #1 PASS SEARCH
        #check for input size of decimal places (can be changed by user)
        #for loop that runs from 23 to 25 at increments of 0.01
        for (tau in seq(from = 23.0, to = 26.0, by = 0.1)) {
            #Calculating the t1 values for each row
            time1 <-
                df$elapsed_time_hrs - floor(df$elapsed_time_hrs / tau) * tau

            #Calculating the x values using t1 for each row
            #Circadian Signal
            circ_metrics <- xVal(2, tau, time1)

            OUTCOME.data <-
                cbind(NOSA_outcome, circ_metrics, evok_metrics)

            OUTCOME.new <-
                OUTCOME.data[seq(1, nrow(OUTCOME.data), 1),]

            OUTCOME.y <- OUTCOME.new[, 1]

            OUTCOME.x <- OUTCOME.new[, 2:ncol(OUTCOME.new)]

            #Using Linear Regression Models to estimate u, Beta1 - Beta 10
            #NOSA_fitcome (pg/mL rn) but can be specified for each file
            NOSA_fit <-
                lm(OUTCOME.y ~ OUTCOME.x)

            #Using Linear Regression Models to estimate u, Beta1 - Beta 10
            #NOSA_fitcome (pg/mL rn) but can be specified for each file
            # NOSA_fit <- lm(OUTCOME.y ~ OUTCOME.x)

            #calculating the RSE for each row w/ current taus
            rse <- sum(NOSA_fit$residuals ^ 2)

            #detach here

            #dataframe that holds all the data for one loop
            if (tau == 23.0) {
                df_final <- c(tau, rse)
                df_rse <- rse
            }
            else{
                df_final <- rbind(df_final, c(tau, rse))
                df_rse <- cbind(df_rse, rse)
            }

            #attach original df here
        }

        #finding the min rse and min tau values from dataframe
        min_rse <- min(df_rse)
        min_tau <- df_final[(df_final[, 2] == min_rse), 1]

        #print(df_rse)

        #removing all unecessary elements to save memory
        rm(time1)
        rm(circ_metrics)
        rm(OUTCOME.data)
        rm(OUTCOME.new)
        rm(OUTCOME.y)
        rm(OUTCOME.x)
        rm(NOSA_fit)
        rm(rse)
        rm(min_rse)
        rm(df_rse)


        #print(min_tau)

        #-------------------------------------------------
        ## FOR LOOP
        #check for input size of decimal places (can be changed by user)
        #for loop that runs from 23 to 25 at increments of 0.01
        for (tau in seq(from = min_tau - 0.1,
                        to = min_tau + 0.1,
                        by = 0.01)) {
            #Calculating the t1 values for each row
            time1 <-
                df$elapsed_time_hrs - floor(df$elapsed_time_hrs / tau) * tau

            #Calculating the x values using t1 for each row
            #Circadian Signal
            circ_metrics <- xVal(2, tau, time1)

            OUTCOME.data <-
                cbind(NOSA_outcome, circ_metrics, evok_metrics)


            OUTCOME.new <-
                OUTCOME.data[seq(1, nrow(OUTCOME.data), 1),]

            OUTCOME.y <- OUTCOME.new[, 1]

            OUTCOME.x <- OUTCOME.new[, 2:ncol(OUTCOME.new)]

            #Using Linear Regression Models to estimate u, Beta1 - Beta 10
            #NOSA_fitcome (pg/mL rn) but can be specified for each file
            NOSA_fit <-
                lm(OUTCOME.y ~ OUTCOME.x)
            #Using Linear Regression Models to estimate u, Beta1 - Beta 10
            #NOSA_fitcome (pg/mL rn) but can be specified for each file
            # NOSA_fit <- lm(OUTCOME.y ~ OUTCOME.x)

            #calculating the RSE for each row w/ current taus
            rse <- sum(NOSA_fit$residuals ^ 2)

            #detach here


            #creating a final dataframe
            if (tau == min_tau - 0.1) {
                df_final <- c(tau, rse)
                df_rse <- rse
            }
            else{
                df_final <- rbind(df_final, c(tau, rse))
                df_rse <- cbind(df_rse, rse)
            }

            #attach here

        }

        #minimum RSE value
        min_rse <- min(df_rse)
        min_tau <- df_final[(df_final[, 2] == min_rse), 1]

        #print(df_rse)

        rm(time1)
        rm(circ_metrics)
        rm(OUTCOME.data)
        rm(OUTCOME.new)
        rm(OUTCOME.y)
        rm(OUTCOME.x)
        rm(NOSA_fit)
        rm(rse)
        rm(min_rse)
        rm(df_rse)

        #print(min_tau)

        #-------------------------------------------------
        ## FOR LOOP
        #check for input size of decimal places (can be changed by user)
        #for loop that runs from 23 to 25 at increments of 0.01
        for (tau in seq(from = min_tau - 0.01,
                        to = min_tau + 0.01,
                        by = 0.001)) {
            #Calculating the t1 values for each row
            time1 <-
                df$elapsed_time_hrs - floor(df$elapsed_time_hrs / tau) * tau

            #Calculating the x values using t1 for each row
            #Circadian Signal
            circ_metrics <- xVal(2, tau, time1)

            OUTCOME.data <-
                cbind(NOSA_outcome, circ_metrics, evok_metrics)

            OUTCOME.new <-
                OUTCOME.data[seq(1, nrow(OUTCOME.data), 1),]

            OUTCOME.y <- OUTCOME.new[, 1]

            OUTCOME.x <- OUTCOME.new[, 2:ncol(OUTCOME.new)]

            #Using Linear Regression Models to estimate u, Beta1 - Beta 10
            #NOSA_fitcome (pg/mL rn) but can be specified for each file
            NOSA_fit <-
                lm(OUTCOME.y ~ OUTCOME.x,)
            #Using Linear Regression Models to estimate u, Beta1 - Beta 10
            #NOSA_fitcome (pg/mL rn) but can be specified for each file
            # NOSA_fit <- lm(OUTCOME.y ~ OUTCOME.x)

            #calculating the RSE for each row w/ current taus
            rse <- sum(NOSA_fit$residuals ^ 2)

            #detach here


            #creating a final dataframe
            if (tau == min_tau - 0.01) {
                df_final <- c(tau, rse)
                df_rse <- rse
            }
            else{
                df_final <- rbind(df_final, c(tau, rse))
                df_rse <- cbind(df_rse, rse)
            }

        }

        #minimum RSE value
        min_rse <- min(df_rse)
        min_tau <- df_final[(df_final[, 2] == min_rse), 1]

        #print(df_rse)

        rm(time1)
        rm(circ_metrics)
        rm(OUTCOME.data)
        rm(OUTCOME.new)
        rm(OUTCOME.y)
        rm(OUTCOME.x)
        rm(NOSA_fit)
        rm(rse)
        rm(df_rse)

        #print(min_tau)

        #--------------------------------#
        #FINAL RUN

        #Calculating the t1 values for each row
        time1 <-
            df$elapsed_time_hrs - floor(df$elapsed_time_hrs / min_tau) * min_tau

        #Calculating the x values using t1 for each row
        #Circadian Signal
        circ_metrics <- xVal(2, min_tau, time1)

        OUTCOME.data <-
            cbind(NOSA_outcome, circ_metrics, evok_metrics)

        OUTCOME.new <- OUTCOME.data[seq(1, nrow(OUTCOME.data), 1),]

        OUTCOME.y <- OUTCOME.new[, 1]

        OUTCOME.x <- OUTCOME.new[, 2:ncol(OUTCOME.new)]

        #Using Linear Regression Models to estimate u, Beta1 - Beta 10

        NOSA_fit <-
            lm(OUTCOME.y ~ OUTCOME.x)

        #calculating the RSE for each row w/ current taus
        rse <- sum(NOSA_fit$residuals ^ 2)

        # #extracting needed coefficients from lm model
        est_mean <- NOSA_fit$coefficients[1]

        #loop that calculates the amplitudes
        for (j in seq(from = 1,
                      to = num_harmonics + 2,
                      by = 1)) {
            amp[j] <-
                sqrt(NOSA_fit$coefficients[2 * j] ^ 2 + NOSA_fit$coefficients[2 * j + 1] ^
                         2)
        }

        #detach here
        df.output <- c(min_tau, est_mean, min_rse, amp)

        #View(x = df.output, title = "Final")
        return(df.output)
    }






