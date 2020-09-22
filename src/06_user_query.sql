BEGIN

CREATE TEMPORARY TABLE all_pairs AS (
  SELECT pair
  FROM uniswap_v1_pairs
  UNION ALL
  SELECT pair
  from uniswap_v2_pairs
);
-- returns all addresses that interacted with uniswap
CREATE TABLE user_query AS (
  WITH tokens AS (
    SELECT token
    FROM uniswap_v1_pairs
    UNION
    ALL
    SELECT token0 AS token
    FROM uniswap_v2_pairs
    UNION
    ALL
    SELECT token1 AS token
    FROM uniswap_v2_pairs
  ),
  token_transfer_senders AS (
      SELECT *
      FROM `bigquery-public-data.crypto_ethereum.token_transfers`
      WHERE
        (token_address IN (SELECT token FROM tokens) OR token_address IN (SELECT pair FROM all_pairs))
        AND to_address IN (
            SELECT contract
            FROM uniswap_contracts
        )
        AND from_address IN ('0x0aa70981311d60a9521c99cecfdd68c3e5a83b83', '0x1e30124fde14533231216d95f7798cd0061e5cf8', '0x880a845a85f843a5c67db2061623c6fc3bb4c511', '0xff92ada50cdc8009686867b4a470c8769bedb22d')
        AND block_timestamp < @cutoff_timestamp
  )
  SELECT *
  FROM (
      SELECT *
      FROM token_transfer_senders
    )
  WHERE from_address NOT IN (
      SELECT contract
      FROM uniswap_contracts
  )
);

END;