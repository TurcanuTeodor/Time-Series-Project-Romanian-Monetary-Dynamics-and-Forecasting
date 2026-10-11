# Time Series Project: Romanian Monetary Dynamics and Forecasting

[![R](https://img.shields.io/badge/R-4.x-276DC3?logo=r&logoColor=white)](https://www.r-project.org/)
[![Methodology](https://img.shields.io/badge/Methods-ARIMA%20%7C%20VECM%20%7C%20Johansen-0F766E)]()
[![Data](https://img.shields.io/badge/Data-Monthly%20Macro%20Series-7C3AED)]()

## Executive Summary

This project analyzes Romania's monetary and inflation dynamics using monthly time series data from 1996 onward. The work is split into two complementary applications:

1. A univariate forecasting exercise for the Harmonised Index of Consumer Prices (HICP), where the Box-Jenkins methodology is used to identify, estimate, validate, and forecast an ARIMA model.
2. A multivariate econometric study of inflation, money market interest rates, and credit volume using cointegration tools, a VECM framework, and impulse response analysis.

The main finding is that Romanian inflation is persistent, structurally shaped by long-run macroeconomic shifts, and responsive to monetary policy transmission channels. The best ARIMA specification in the study is ARIMA(1,2,1)(1,0,2)[12], which delivers strong in-sample fit and stable 12-month forecasts. In the multivariate application, the Johansen framework supports a cointegrated system with a restricted rank of 2, and impulse responses show that ROBOR shocks reduce both inflation and credit growth over time.

## Project Highlights

- Monthly Romanian data covering the transition period, EU accession era, and post-pandemic inflation shock.
- Classical Box-Jenkins workflow with ADF testing, ACF/PACF inspection, model comparison, residual diagnostics, and forecasting.
- Cointegration-based macroeconomic analysis using Johansen tests, VECM estimation, IRFs, and multivariate forecasts.
- Recruiter-friendly structure with clear outputs, model choices, and reproducible run instructions.

## Models Used

### Application 1: HICP Forecasting

- Log transformation of the HICP index.
- Augmented Dickey-Fuller stationarity testing.
- Candidate ARIMA models:
  - ARIMA(1,1,0)
  - ARIMA(0,1,1)
  - ARIMA(1,1,1)
  - ARIMA(1,2,1)(1,0,2)[12]
- Final selected model: ARIMA(1,2,1)(1,0,2)[12]

### Application 2: Monetary Dynamics

- Log-differenced HICP.
- Differenced ROBOR 3M.
- Log-differenced credit volume.
- Johansen cointegration test.
- VAR lag selection.
- VECM estimated from the cointegrated system.
- Impulse response functions and 12-month forecast.

## Key Results

### ARIMA Results

| Metric | Value |
| --- | ---: |
| Selected model | ARIMA(1,2,1)(1,0,2)[12] |
| Log-likelihood | 1038.83 |
| AIC | -2065.65 |
| BIC | -2042.32 |
| ME | -0.000777 |
| RMSE | 0.01342 |
| MAE | 0.006874 |
| MAPE | 0.3160% |
| MASE | 0.05075 |
| Residual ACF(1) | 0.00765 |

### VECM and Cointegration Results

| Item | Result |
| --- | --- |
| Variables | HICP, ROBOR 3M, Credit Volume |
| Optimal VAR lag | 12 |
| Johansen trace test | Evidence of cointegration |
| Restricted cointegration rank | 2 |
| Main IRF finding | ROBOR shocks reduce inflation and credit over time |

## Visual Placeholders

Replace these placeholders with exported figures from your final analysis.

### Architecture Diagram

![Project Architecture](docs/diagrams/architecture.png)

### Model Performance Charts

![ARIMA diagnostics](docs/charts/arima-diagnostics.png)

![Forecast accuracy](docs/charts/forecast-performance.png)

### Multivariate Analysis Charts

![Johansen cointegration](docs/charts/johansen-test.png)

![Impulse response functions](docs/charts/irf.png)

![VECM forecast](docs/charts/vecm-forecast.png)

## Repository Structure

```text
.
├── Data/
├── README.md
├── .gitignore
└── R-Project/
    ├── R-Project.Rproj
    ├── Script-Application1-ARIMA.R
    └── Script-Application2-VECM.R
```

## Methodology

### Application 1: ARIMA Forecasting Workflow

1. Load the monthly HICP series.
2. Inspect the level series and its log transformation.
3. Test for stationarity with the Augmented Dickey-Fuller test.
4. Difference the logged series to obtain a stationary inflation measure.
5. Examine ACF and PACF plots to identify candidate ARIMA structures.
6. Estimate competing models and compare AIC/BIC.
7. Validate the selected model through residual diagnostics.
8. Produce 12-month-ahead forecasts with confidence intervals.

### Application 2: VECM Workflow

1. Load HICP, ROBOR 3M, and credit volume data.
2. Transform series into logarithmic or differenced form as appropriate.
3. Test stationarity and estimate the lag order for the VAR system.
4. Apply Johansen cointegration testing.
5. Estimate the VECM with the chosen cointegration rank.
6. Analyze impulse response functions for monetary policy shocks.
7. Generate a 12-month forecast for the system.

## How to Run

### Prerequisites

- R and RStudio installed.
- The following packages available in your R environment:
  - `readxl`
  - `tseries`
  - `forecast`
  - `lmtest`
  - `urca`
  - `vars`

### Run in RStudio

1. Open `R-Project/R-Project.Rproj` in RStudio.
2. Make sure the data files are available in the `Data/` folder.
3. Open `Script-Application1-ARIMA.R` to run the univariate HICP analysis.
4. Open `Script-Application2-VECM.R` to run the multivariate monetary dynamics analysis.
5. Execute the scripts from top to bottom.

### Run from the Console

From the `R-Project/` directory, you can source each script directly:

```r
source("Script-Application1-ARIMA.R")
source("Script-Application2-VECM.R")
```

### Notes on Data Paths

- The scripts expect data files to be available under `../Data/` when run from the `R-Project/` folder.
- If you change the folder layout, update the paths inside the scripts accordingly.

## Data Sources

- Eurostat / FRED for HICP.
- National Bank of Romania for ROBOR and credit-related series.

## Results Interpretation

- The HICP series is non-stationary in levels and becomes suitable for modeling after logarithmic differencing.
- The selected ARIMA model captures both persistence and seasonal dynamics in Romanian inflation.
- The multivariate system suggests a stable long-run relationship between inflation, interest rates, and credit volume.
- Higher ROBOR levels are associated with lower inflation and lower credit demand over the forecast horizon.

## Deliverables for Recruiters

- A complete univariate forecasting pipeline.
- A multivariate monetary transmission analysis.
- Interpretable diagnostics and forecast outputs.
- Reproducible R scripts organized for review.

## Suggested Enhancements

If you want to make the repository even stronger for recruiters, consider adding:

- Exported figures in `docs/`.
- A short methodology PDF or presentation.
- A rendered HTML or PDF report.
- A screenshot of the final forecast plots.

## License

Add your preferred license here before publishing.