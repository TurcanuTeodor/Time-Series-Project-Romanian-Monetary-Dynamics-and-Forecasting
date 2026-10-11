# Packages installation and loading
required_packages <- c("readxl", "tseries", "forecast", "lmtest")
for(pkg in required_packages){
  if(!require(pkg, character.only = TRUE)) install.packages(pkg, dependencies = TRUE)
  library(pkg, character.only = TRUE)
}

# Data loading
if(file.exists("../Data/HICP.xlsx")) {
  df_hicp <- read_excel("../Data/HICP.xlsx", sheet = 1)
} else {
  df_hicp <- read_excel(file.choose(), sheet = 1)
}

# Time series object creation
hicp_ts <- ts(df_hicp$HICP_value, start = c(1996, 1), frequency = 12)

# Descriptive analysis
stats <- c(summary(hicp_ts), SD = sd(hicp_ts), N = length(hicp_ts))
stats

# Initial plots (Level and Log)
plot(hicp_ts, main="HICP Evolution (Romania)", ylab="HICP_value", xlab="Time", col="pink", lwd=2)

log_hicp <- log(hicp_ts)
plot(log_hicp, main="Log-HICP Evolution (Romania)", ylab="HICP_value", xlab="Time", col="pink", lwd=2)

# Stationarity testing
adf_level <- adf.test(log_hicp, alternative = "stationary")
adf_level

# Differenced series (Monthly inflation rate)
d_log_hicp <- diff(log_hicp)
plot(d_log_hicp, main="Monthly Inflation Rate (Logged & Differenced)", ylab="HICP_value", xlab="Time", col="red")

adf_diff <- adf.test(d_log_hicp, alternative = "stationary")
adf_diff

# Model identification
# Correlograms (ACF & PACF)
Acf(d_log_hicp, lag.max = 40, main = "ACF of Inflation")
Pacf(d_log_hicp, lag.max = 40, main = "PACF of Inflation")

# Candidate models estimation
model_ar1    <- Arima(log_hicp, order = c(1, 1, 0))
model_ma1    <- Arima(log_hicp, order = c(0, 1, 1))
model_arma11 <- Arima(log_hicp, order = c(1, 1, 1))
model_auto   <- Arima(log_hicp, order = c(1, 2, 1), seasonal = list(order = c(1, 0, 2), period = 12))

# Model comparison table
compare_models <- data.frame(
  Model_Type = c("Manual AR(1): ARIMA(1,1,0)", "Manual MA(1): ARIMA(0,1,1)", "Manual ARMA(1,1): ARIMA(1,1,1)", "ARIMA(1,2,1)(1,0,2)[12]"),
  AIC = c(AIC(model_ar1), AIC(model_ma1), AIC(model_arma11), AIC(model_auto)),
  BIC = c(BIC(model_ar1), BIC(model_ma1), BIC(model_arma11), BIC(model_auto))
)
compare_models

# Model estimation and validation
summary(model_auto)

# Significance calculation
coefficients <- model_auto$coef
se <- sqrt(diag(vcov(model_auto)))
t_ratios <- coefficients / se
significance <- ifelse(abs(t_ratios) > 1.96, "Yes", "No")

table_3_3 <- data.frame(Parameter = names(coefficients), Coefficient = coefficients, Std_Error = se, Ratio = t_ratios, Significant_5pct = significance)
table_3_3

# Residual diagnostics
checkresiduals(model_auto, lag = 36)

# Forecasting
forecasting <- forecast(model_auto, h = 12, level = c(80, 95))
forecasting

# Final forecast plot
plot(forecasting, main = "HICP Forecast for the Next 12 Months", xlab = "Time", ylab = "Log scale", include = 100)
