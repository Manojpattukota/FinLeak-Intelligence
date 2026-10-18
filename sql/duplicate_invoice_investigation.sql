-- FinLeak Intelligence
-- Identify potential duplicate invoices and prioritize investigation.
-- A duplicate match is a review signal, not proof of fraud.

USE projectt;

SELECT
    s.supplier_name,
    i.supplier_id,
    i.invoice_number,
    COUNT(*) AS invoice_count,
    SUM(i.invoice_amount) AS combined_invoice_value,
    SUM(
        CASE
            WHEN i.invoice_status = 'Paid' THEN i.invoice_amount
            ELSE 0
        END
    ) AS total_paid_value,
    SUM(
        CASE
            WHEN i.invoice_status = 'Paid' THEN 1
            ELSE 0
        END
    ) AS paid_invoice_count,
    SUM(
        CASE
            WHEN i.invoice_status = 'Pending' THEN 1
            ELSE 0
        END
    ) AS pending_invoice_count,
    CASE
        WHEN SUM(
            CASE WHEN i.invoice_status = 'Paid' THEN 1 ELSE 0 END
        ) > 1 THEN 'High Priority - Multiple Paid'
        WHEN SUM(
            CASE WHEN i.invoice_status = 'Paid' THEN 1 ELSE 0 END
        ) = 1 THEN 'Review - One Paid'
        ELSE 'Review - No Paid'
    END AS investigation_priority
FROM Invoices AS i
JOIN Suppliers AS s
    ON i.supplier_id = s.supplier_id
GROUP BY
    s.supplier_name,
    i.supplier_id,
    i.invoice_number
HAVING COUNT(*) > 1
ORDER BY
    paid_invoice_count DESC,
    combined_invoice_value DESC;
