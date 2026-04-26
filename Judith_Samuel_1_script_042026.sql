-- commandes récentes de moins de 3 mois que les clients ont reçues avec au moins 3 jours de retard
WITH maintenant AS (
    SELECT 
        MAX(order_purchase_timestamp) AS max_timestamp 
    FROM orders 
)
SELECT count(*)
FROM orders
CROSS JOIN maintenant
WHERE 
    order_status != 'canceled'
    AND order_delivered_customer_date IS NOT NULL
    AND DATE(order_purchase_timestamp) >= DATE(max_timestamp, '-3 months')
    AND order_delivered_customer_date > DATE(order_estimated_delivery_date, '+3 days');


-- vendeurs ayant généré un chiffre d'affaires de plus de 100000 Real sur des commandes livrées via Olist
WITH seller_revenue AS (
    SELECT
        s.seller_id,
        SUM(oi.price + oi.freight_value) AS total_revenue
    FROM sellers s
    INNER JOIN order_items oi ON s.seller_id = oi.seller_id
    INNER JOIN orders o ON oi.order_id = o.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY s.seller_id
)
SELECT 
    s.seller_id,
    s.seller_city,
    sr.total_revenue,
    COUNT(DISTINCT oi.order_id) AS nb_commandes
FROM sellers s
INNER JOIN seller_revenue sr ON s.seller_id = sr.seller_id
INNER JOIN order_items oi ON s.seller_id = oi.seller_id
WHERE sr.total_revenue > 100000
GROUP BY s.seller_id
ORDER BY sr.total_revenue DESC;


-- nouveaux vendeurs (moins de 3 mois d'ancienneté) qui sont déjà très engagés avec la plateforme (ayant déjà vendu plus de 30 produits)
WITH from_now AS (
    SELECT 
        MAX(order_purchase_timestamp) AS max_timestamp 
    FROM orders o WHERE order_status != 'canceled'
),
seller_activity AS (
    SELECT
        s.seller_id,
        MIN(DATE(o.order_purchase_timestamp)) AS first_sale_date,
        COUNT(DISTINCT oi.product_id) AS unique_products
    FROM sellers s
    INNER JOIN order_items oi ON s.seller_id = oi.seller_id
    INNER JOIN orders o ON oi.order_id = o.order_id
    GROUP BY s.seller_id
)
SELECT 
    sa.seller_id,
    sa.first_sale_date,
    sa.unique_products,
    s.seller_city,
    m.max_timestamp
FROM seller_activity sa
INNER JOIN sellers s ON sa.seller_id = s.seller_id
CROSS JOIN from_now m
WHERE DATE(sa.first_sale_date) > DATE(max_timestamp, '-3 months')
    AND sa.unique_products > 30;


-- codes postaux, enregistrant plus de 30 reviews, avec le pire review score moyen sur les 12 derniers mois
WITH from_now AS (
    SELECT 
        MAX(order_purchase_timestamp) AS max_timestamp 
    FROM orders o WHERE order_status != 'canceled'
), zip_stats AS (
    SELECT
        c.customer_zip_code_prefix,
        AVG(rev.review_score) AS avg_score,
        COUNT(rev.review_id) AS total_reviews
    FROM customers c
    INNER JOIN orders o ON c.customer_id = o.customer_id
    INNER JOIN order_reviews rev ON o.order_id = rev.order_id
    CROSS JOIN from_now n
    WHERE DATE(rev.review_answer_timestamp) >= DATE(n.max_timestamp, '-1 year')
    GROUP BY c.customer_zip_code_prefix
)
SELECT *
FROM zip_stats
WHERE total_reviews > 30
ORDER BY avg_score ASC
LIMIT 5;
