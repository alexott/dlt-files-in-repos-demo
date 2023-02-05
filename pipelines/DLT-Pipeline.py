# Databricks notebook source
# This notebook shows how to use files in repos functionality in Delta Live Tables.

# COMMAND ----------

# import helper functions from the current repository
import helpers.columns_helpers as ch

# COMMAND ----------

import dlt

# COMMAND ----------

# get data path from the DLT Pipeline configuration so we can test the pipeline with smaller amount of data
default_json_path = "/databricks-datasets/wikipedia-datasets/data-001/clickstream/raw-uncompressed-json/"
json_path = spark.conf.get("my_etl.data_path", default_json_path)
print(f"Loading data from {json_path}")

# COMMAND ----------

@dlt.table(
   comment="The raw wikipedia clickstream dataset, ingested from /databricks-datasets."
)
def clickstream_raw():
  return spark.read.format("json").load(json_path)

# COMMAND ----------

@dlt.table(
  comment="Leave only links, and exclude some columns from dataset"
)
@dlt.expect_or_drop("only links", "type is not null and type in ('link', 'redlink')")
def clickstream_filtered():
  df = dlt.read("clickstream_raw")
  # use imported function
  new_cols = ch.columns_except(df, ['prev_id', 'prev_title'])
  return df.select(*new_cols)
