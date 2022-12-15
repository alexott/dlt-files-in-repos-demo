# Databricks notebook source
# This notebook shows how to use files in repos functionality in Delta Live Tables.

# COMMAND ----------

# import helper functions from the current repository
import helpers.columns_helpers as ch

# COMMAND ----------

json_path = "/databricks-datasets/wikipedia-datasets/data-001/clickstream/raw-uncompressed-json/2015_2_clickstream.json"

# COMMAND ----------

import dlt

@dlt.table(
   comment="The raw wikipedia clickstream dataset, ingested from /databricks-datasets."
)
def clickstream_raw():
  df = spark.read.format("json").load(json_path)
  # use imported function
  new_cols = ch.columns_except(df, ['prev_id', 'prev_title'])
  return df.select(*new_cols)
