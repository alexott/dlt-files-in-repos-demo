# Databricks notebook source
# This notebook defines tests for DLT pipeline
# It could be defined in SQL as well (potentially i)

# COMMAND ----------

import dlt

# COMMAND ----------

@dlt.table(comment="Check number of records")
@dlt.expect_or_fail("valid count", "count = 12480649 or count = 0") # we need to check for 0 because DLT first evaluates with empty dataframe
def filtered_count_check():
  cnt = dlt.read("clickstream_filtered").count()
  return spark.createDataFrame([[cnt]], schema="count long")

# COMMAND ----------

@dlt.table(comment="Check type")
@dlt.expect_all_or_fail({"valid type": "type in ('link', 'redlink')",
                         "type is not null": "type is not null"})
def filtered_type_check():
  return dlt.read("clickstream_filtered").select("type")
