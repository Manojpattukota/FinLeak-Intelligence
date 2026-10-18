-- FinLeak Intelligence
-- Invoice status and financial summary analysis

USE projectt;

-- 1. Overall invoice metrics
SELECT
    COUNT(*) AS total_invoices,
    SUM(invoice_amount) AS total_invoice_value,
    AVG(invoice_amount) AS average_invoice_value
FROM Invoices;

-- 2. Invoice count and value by status
SELECT
    invoice_status,
    COUNT(*) AS invoice_count,
    SUM(invoice_amount) AS total_invoice_value,
    AVG(invoice_amount) AS average_invoice_value
FROM Invoices
GROUP BY invoice_status
ORDER BY total_invoice_value DESC;

-- 3. Suppliers with the highest total invoice value
SELECT
    s.supplier_name,
    COUNT(i.invoice_id) AS invoice_count,
    SUM(i.invoice_amount) AS total_invoice_value
FROM Suppliers AS s
JOIN Invoices AS i
    ON s.supplier_id = i.supplier_id
GROUP BY s.supplier_id, s.supplier_name
ORDER BY total_invoice_value DESC
LIMIT 10;

-- 4. Monthly invoice trend
SELECT
    DATE_FORMAT(invoice_date, '%Y-%m') AS invoice_month,
    COUNT(*) AS invoice_count,
    SUM(invoice_amount) AS total_invoice_value
FROM Invoices
WHERE invoice_date IS NOT NULL
GROUP BY DATE_FORMAT(invoice_date, '%Y-%m')
ORDER BY invoice_month;
