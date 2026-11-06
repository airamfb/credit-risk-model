# Credit Risk Modeling & Expected Loss Analysis

End-to-end credit risk modeling project built with **Python, SQL and interpretable statistical techniques**.

The project estimates borrower **Probability of Default (PD)**, analyzes the main drivers of credit risk, segments borrowers into risk categories and translates predicted probabilities into an illustrative **Expected Loss (EL)** framework.

---

## Project Objective

The objective is to develop an interpretable credit risk workflow capable of:

- Estimating borrower Probability of Default
- Identifying major credit risk drivers
- Ranking borrowers according to predicted risk
- Creating risk bands and deciles
- Evaluating model discrimination and calibration
- Estimating scenario-based Expected Loss
- Performing portfolio-level analysis using SQL

The project emphasizes both **predictive performance and financial interpretation**.

---

## Dataset

The project uses the **Give Me Some Credit** dataset.

The original dataset contains approximately **150,000 borrower observations** and includes information such as:

- Revolving credit utilization
- Borrower age
- Debt ratio
- Monthly income
- Number of open credit lines
- Real estate loans
- Delinquency history
- Number of dependents

### Target Variable

`SeriousDlqin2yrs`

Where:

- `0` = no serious financial distress
- `1` = serious financial distress within two years

After data-quality cleaning, the modeling dataset contained:

**149,730 observations**

The default rate was approximately:

**6.60%**

Because the target is highly imbalanced, model evaluation does not rely on accuracy alone.

---

## Project Workflow

The project follows an end-to-end credit risk modeling process:

1. Data understanding
2. Data quality and anomaly detection
3. Exploratory Data Analysis
4. Missing-value analysis
5. Data preprocessing
6. Weight of Evidence transformation
7. Information Value analysis
8. Logistic Regression modeling
9. Model comparison
10. Train / Validation / Test framework
11. Threshold optimization
12. Probability of Default estimation
13. Risk-band segmentation
14. Expected Loss analysis
15. SQL portfolio analysis

---

## Data Quality

Several data-quality issues were identified during exploratory analysis.

Examples included:

- One borrower with an age of zero
- Unusual delinquency values of `96` and `98`
- Missing Monthly Income values
- Missing Number of Dependents
- Extreme values in revolving credit utilization
- Extremely high Debt Ratio observations

Anomalous delinquency values and the invalid age observation were removed.

Missing values were treated using training-sample medians to prevent data leakage.

Missingness patterns were also analyzed because missing information itself can contain predictive information.

---

## Exploratory Data Analysis

Several strong relationships with default were observed.

### Revolving Credit Utilization

Borrowers with high revolving credit utilization exhibited substantially higher default rates.

### Delinquency History

Past-due behavior was one of the strongest indicators of future default.

Default rates increased sharply with:

- 30–59 day delinquency
- 60–89 day delinquency
- 90+ day delinquency

### Age

Default risk generally declined as borrower age increased.

### Monthly Income

Higher income groups showed lower observed default rates.

### Debt Ratio

Debt Ratio displayed a more complex nonlinear relationship with default and was strongly associated with missing income observations.

---

## Weight of Evidence & Information Value

Weight of Evidence (WOE) transformation was used to capture nonlinear relationships while preserving interpretability.

Information Value analysis identified the strongest risk drivers.

Some of the highest-IV variables included:

| Variable | Approx. IV |
|---|---:|
| Revolving Credit Utilization | 1.105 |
| 90+ Day Delinquency | 0.853 |
| 60–89 Day Delinquency | 0.572 |
| 30–59 Day Delinquency | 0.452 |
| Age | 0.252 |
| Debt Ratio | 0.083 |
| Monthly Income | 0.072 |

Variables with unusually high IV were reviewed carefully rather than automatically interpreted as superior predictors.

---

## Model Comparison

Three Logistic Regression approaches were initially compared:

| Model | ROC-AUC |
|---|---:|
| All raw features | 0.8072 |
| IV-selected features | 0.8066 |
| WOE Logistic Regression | 0.8492* |

\*Development-stage result before the final holdout validation framework.

The WOE model provided a substantial improvement in discrimination while maintaining strong interpretability.

---

## Final Validation Framework

To obtain a more reliable performance estimate, the data was divided into:

- **70% Training**
- **15% Validation**
- **15% Test**

The Training set was used to:

- Learn missing-value treatment
- Create WOE bins
- Estimate WOE values
- Train the Logistic Regression model

The Validation set was used to:

- Select the classification threshold

The Test set remained untouched until the final evaluation.

This prevents threshold selection from contaminating the final performance estimate.

---

## Final Model Performance

The final WOE Logistic Regression produced:

| Metric | Result |
|---|---:|
| Validation ROC-AUC | 0.8589 |
| **Final Test ROC-AUC** | **0.8461** |
| Brier Score | 0.0502 |
| Selected Threshold | 0.16 |
| Default Precision | 37% |
| Default Recall | 47% |
| Default F1 Score | 0.42 |
| Overall Accuracy | 91% |

The final classification threshold was selected using the Validation set rather than the Test set.

At the selected threshold, the final confusion matrix was:

```text
                Predicted
              No Default   Default
Actual
No Default       19,791      1,187
Default             779        703
```

The lower threshold increases detection of risky borrowers compared with the standard 0.50 threshold, at the cost of additional false positives.

---

## Probability of Default

The final model produces an individual **Probability of Default (PD)** for each borrower.

Borrowers were segmented into five risk bands:

- Very Low
- Low
- Moderate
- High
- Very High

The predicted probabilities showed strong risk differentiation.

| Risk Band | Borrowers | Avg. PD | Actual Default Rate |
|---|---:|---:|---:|
| Very Low | 15,679 | 2.13% | 1.93% |
| Low | 3,606 | 7.17% | 8.37% |
| Moderate | 1,675 | 13.64% | 15.10% |
| High | 840 | 27.51% | 32.02% |
| Very High | 660 | 60.80% | 53.79% |

Observed default rates increase substantially across the risk bands, confirming meaningful borrower segmentation.

---

## Risk Decile Analysis

Borrowers were ranked from highest to lowest predicted PD and divided into ten equal-sized risk deciles.

The model demonstrated strong concentration of defaults among the highest-risk borrowers.

| Highest-Risk Population | Cumulative Defaults Captured |
|---|---:|
| Top 10% | **50.81%** |
| Top 20% | **68.08%** |
| Top 30% | **79.35%** |
| Top 40% | 86.50% |
| Top 50% | 91.36% |

The highest-risk decile had an observed default rate of approximately:

**33.53%**

while the lowest-risk decile had an observed default rate of approximately:

**0.53%**

This demonstrates strong borrower ranking performance.

---

## Expected Loss

Expected Loss is calculated using:

```text
Expected Loss = PD × LGD × EAD
```

The dataset does not contain observed **Loss Given Default (LGD)** or **Exposure at Default (EAD)**.

Therefore, the project uses illustrative assumptions:

- **LGD = 45%**
- **EAD = 10,000 monetary units per borrower**

These values are used only to demonstrate the Expected Loss methodology and should not be interpreted as actual portfolio exposures.

Under these assumptions, the final test portfolio generated approximately:

**6.54 million monetary units of Expected Loss**

The scenario demonstrates how borrower-level PD estimates can be translated into portfolio-level financial risk measures.

---

## SQL Portfolio Analysis

SQLite and SQL were used to analyze the final model output.

The SQL analysis includes:

- Total borrowers
- Average portfolio PD
- Observed default rate
- Total scenario EAD
- Total Expected Loss
- Risk-band aggregation
- High-risk borrower concentration
- Risk deciles
- Cumulative default capture
- Highest-PD borrowers

Example questions answered using SQL include:

> What percentage of the portfolio belongs to the High and Very High risk categories?

> How much Expected Loss is concentrated in high-risk borrowers?

> What percentage of observed defaults is captured by the highest-risk 10%, 20% and 30% of borrowers?

The SQL queries are available in:

```text
sql/portfolio_analysis.sql
```

---

## Project Structure

```text
credit-risk-model/
│
├── data/
│   ├── raw/
│   └── processed/
│       └── final_credit_risk_results.csv
│
├── notebooks/
│   ├── 01_data_understanding.ipynb
│   ├── 02_eda.ipynb
│   ├── 03_preprocessing.ipynb
│   ├── 04_woe_iv.ipynb
│   ├── 05_modeling.ipynb
│   ├── 06_final_validation.ipynb
│   └── 07_sql_analysis.ipynb
│
├── reports/
│   └── figures/
│
├── sql/
│   └── portfolio_analysis.sql
│
├── src/
│
├── .gitignore
├── requirements.txt
└── README.md
```

---

## Visualizations

The project includes several visual outputs:

- Default rate by credit utilization
- Default rate by age
- Default rate by delinquency history
- Default rate by income
- Default rate by Debt Ratio
- Missing-income risk analysis
- Threshold analysis
- ROC Curve
- Calibration Curve

Figures are stored in:

```text
reports/figures/
```

---

## Technologies

### Programming

- Python
- SQL

### Python Libraries

- Pandas
- NumPy
- Scikit-learn
- Matplotlib

### Data & Development

- SQLite
- Jupyter Notebook
- Git
- GitHub

---

## Installation

Clone the repository:

```bash
git clone https://github.com/airamfb/credit-risk-model.git
```

Move into the project directory:

```bash
cd credit-risk-model
```

Install the required Python packages:

```bash
pip install -r requirements.txt
```

---

## Dataset Setup

The raw dataset is not included in the repository.

Download the **Give Me Some Credit** dataset and place:

```text
cs-training.csv
```

inside:

```text
data/raw/
```

The raw data directory is excluded from version control through `.gitignore`.

---

## Limitations

This project is intended as an analytical and portfolio project rather than a production credit decision system.

Important limitations include:

- The dataset is anonymized and historical.
- The analysis does not include macroeconomic variables.
- LGD and EAD are illustrative assumptions rather than observed values.
- The operational threshold is selected using F1 score rather than an institution-specific financial cost function.
- No temporal out-of-time validation is available.
- Production implementation would require model monitoring, governance and stability testing.
- Regulatory use would require substantially more validation and documentation.

---

## Potential Improvements

Future development could include:

- Probability calibration techniques
- Population Stability Index (PSI)
- Out-of-time validation
- Cost-sensitive threshold optimization
- Champion / challenger model comparison
- Gradient Boosting models
- SHAP-based model interpretation
- Scorecard development
- Macroeconomic stress scenarios
- LGD and EAD modeling using appropriate datasets
- Model monitoring dashboard

---

## Key Takeaways

The final model achieved an out-of-sample **ROC-AUC of 0.846**, demonstrating strong discriminatory power.

The highest-risk:

- **10% of borrowers captured 50.8% of defaults**
- **20% captured 68.1%**
- **30% captured 79.4%**

The project demonstrates how statistical modeling can be connected with financial risk concepts including:

**Probability of Default, borrower segmentation, portfolio risk concentration and Expected Loss.**

---

## Author

**Airam Fortunato**

Financial Engineering student focused on Data Analytics, Risk Management, Data Science and Quantitative Finance.