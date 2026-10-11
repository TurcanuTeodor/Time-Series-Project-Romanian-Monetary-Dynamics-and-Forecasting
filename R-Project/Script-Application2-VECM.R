if(!require(readxl)) install.packages("readxl")
library(readxl)
library(tseries)
library(urca)
library(lmtest)
library(vars)

if(file.exists("../Data/Variables.xlsx")) {
  df <- read_excel("../Data/Variables.xlsx", sheet = 1)
} else {
  df <- read_excel(file.choose(), sheet = 1)
}

Variables <- df 

print("Column names found:")
print(colnames(df))

# Create Time Series objects
hicp_ts   <- ts(df$`HICP_value`, start = c(1996, 1), frequency = 12)
robor_ts  <- ts(df$`ROBOR 3M`, start = c(1996, 1), frequency = 12)
credit_ts <- ts(df$`Credit Volume EUR(Millions)`, start = c(1996, 1), frequency = 12)

# Transformations
log_hicp   <- log(hicp_ts)
log_credit <- log(credit_ts)

d_log_hicp   <- diff(log_hicp)
d_robor      <- diff(robor_ts)
d_log_credit <- diff(log_credit)

# GENERATE OUTPUTS
print("--- SUMMARY FOR TABLE 4.1 ---")
summary(cbind(HICP=hicp_ts, ROBOR=robor_ts, Credit=credit_ts))

print("--- ADF TEST RESULTS (Check p-values) ---")
print(paste("HICP p-value:", adf.test(d_log_hicp)$p.value))
print(paste("ROBOR p-value:", adf.test(d_robor)$p.value))
print(paste("Credit p-value:", adf.test(d_log_credit)$p.value))

# PLOTS
par(mfrow=c(3,1))
plot(d_log_hicp, main="Stationary Inflation (HICP Log-Diff)", col="blue")
plot(d_robor, main="Stationary ROBOR (Diff)", col="red")
plot(d_log_credit, main="Stationary Credit (Log-Diff)", col="green")
par(mfrow=c(1,1)) # Corecție tehnică: resetăm layout-ul pentru a nu strica graficele de mai jos


# JOHANSEN TEST (Use logs/levels)
data_matrix <- cbind(log_hicp, robor_ts, log_credit)
j_test <- ca.jo(data_matrix, type = "trace", ecdet = "const", K = 2)
summary(j_test) 

# GRANGER CAUSALITY (Use differences)
grangertest(d_log_hicp ~ d_robor, order = 2)
grangertest(d_log_credit ~ d_robor, order = 2)


library(vars)

# we transform the variables for manual import
Variables$log_HICP <- log(Variables$HICP_value)
Variables$log_Credit <- log(Variables$`Credit Volume EUR(Millions)`)
Variables$ROBOR <- Variables$`ROBOR 3M`

# create the objects
# we guess the data begins in 1996
data_ts <- ts(Variables[, c("log_HICP", "ROBOR", "log_Credit")], start = c(1996, 1), frequency = 12)

#data cleanup, eliminating NA 
data_ts <- na.omit(data_ts)
# Lag
lag_selection <- VARselect(data_ts, lag.max = 12, type = "const")
print(lag_selection$selection)


#Johansen
library(urca)
#  K = 12 (lag-ul ales)
# ecdet = "const" includem o constanta in relatia de cointegrare
test_johansen <- ca.jo(data_ts, type = "trace", ecdet = "const", K = 12)
summary(test_johansen)



#plots
library(vars)
library(urca)
model_final <- vec2var(test_johansen, r = 2)

irf_hicp <- irf(model_final, 
                impulse = "ROBOR", 
                response = "log_HICP", 
                n.ahead = 24, 
                boot = TRUE)
# Show the plot
plot(irf_hicp, main = "Response of log_HICP to ROBOR Shock")
irf_credit <- irf(model_final, 
                  impulse = "ROBOR", 
                  response = "log_Credit", 
                  n.ahead = 24, 
                  boot = TRUE)
plot(irf_credit, main = "Response of log_Credit to ROBOR Shock")

vecm_forecast <- predict(model_final, n.ahead = 12, ci = 0.95)

plot(vecm_forecast)

