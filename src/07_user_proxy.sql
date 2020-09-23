BEGIN

CREATE TEMPORARY TABLE all_txes AS (
  WITH hashes as (
    SELECT transaction_hash
    FROM wrapper_query
  )
  SELECT from_address, to_address, `hash`
       FROM   `bigquery-public-data.crypto_ethereum.transactions`
       WHERE (`hash` IN (SELECT transaction_hash FROM hashes))
);

CREATE TABLE user_proxy AS (
  WITH cte AS (
    SELECT 
        from_address as user,
        to_address as proxy,
        `hash` as transaction_hash,
        ROW_NUMBER() OVER (
            PARTITION BY 
                to_address
            ORDER BY 
                to_address
        ) row_num
     FROM 
        all_txes
    ) 
   SELECT user, proxy, transaction_hash FROM cte WHERE row_num = 1
);

END;