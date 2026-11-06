-- Portfolio Summary

SELECT
    COUNT(*) AS borrowers,
    AVG(PD) AS average_pd,
    AVG(ActualDefault) AS actual_default_rate,
    SUM(EAD) AS total_ead,
    SUM(ExpectedLoss) AS total_expected_loss
FROM credit_risk_results;


-- Risk Band Analysis

SELECT
    RiskBand,
    COUNT(*) AS borrowers,
    ROUND(AVG(PD), 4) AS average_pd,
    ROUND(AVG(ActualDefault), 4) AS actual_default_rate,
    ROUND(AVG(ExpectedLoss), 2) AS average_expected_loss,
    ROUND(SUM(ExpectedLoss), 2) AS total_expected_loss
FROM credit_risk_results
GROUP BY RiskBand
ORDER BY average_pd;