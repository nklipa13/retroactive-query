# @uniswap/retroactive-query

[![Run Queries](https://github.com/Uniswap/retroactive-query/workflows/Run%20Queries/badge.svg)](https://github.com/Uniswap/retroactive-query/actions?query=workflow%3A%22Run+Queries%22)

This repository contains queries that produce the tables of retroactive UNI token distributions.

The queries run in [Google BigQuery](https://cloud.google.com/bigquery) against the 
[`bigquery-public-data.crypto_ethereum`](https://console.cloud.google.com/bigquery?p=bigquery-public-data&d=crypto_ethereum&page=dataset) 
dataset.

Data for this dataset is extracted to Google BigQuery using
[blockchain-etl/ethereum-etl](https://github.com/blockchain-etl/ethereum-etl).

## Specifications

All queries have a cutoff timestamp of `2020-09-01 00:00:00+00 GMT`. Total distribution is aimed at `150_000_000` UNI.
 
## Reproduction

You can reproduce the results of this query by forking this repository and adding your own secrets to run in your own GCP account.

1. Create a Google Cloud project [here](https://cloud.google.com/) 
1. Find your Project ID in the Google Cloud console [here](https://console.cloud.google.com/)
1. Fork this repository
1. Add the secret `GCP_PROJECT_ID` under Settings > Secrets containing your project ID from the GCP dashboard 
1. Add the secret `GCP_SA_KEY` under Settings > Secrets containing the base64 encoded JSON key of a service account
1. Go to the actions tab of your fork
1. Run the workflow (roughly ~7 minutes to complete)
1. Inspect the resulting user_proxy table

## Verifier

You can verify that no proxy in defiaver_accounts.json had the airdrop by running:
1. `npm install`
2. `node verify.js`

