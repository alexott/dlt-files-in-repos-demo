This repository contains a demo of using [Files in Repos](https://docs.databricks.com/repos/work-with-notebooks-other-files.html#work-with-python-and-r-modules) functionality with [Databricks Delta Live Tables (DLT)](https://docs.databricks.com/workflows/delta-live-tables/index.html) to perform unit & integration testing of DLT pipelines.

More detailed description is available in the blog post [Delta Live Tables Recipes: implementing unit & integration tests](https://alexott.blogspot.com/2022/12/delta-live-tables-recipes-implementing.html). 

TODO: add table of content

# Setup instructions

:construction: Work in progress...

:warning: Setup instructions describe process of performing CI/CD using Azure DevOps (ADO), but similar thing could be implemented with any CI/CD technology.

There are two ways of setting up everything:

1. using Terraform - it's the easiest way of getting everything configured in a short time.  Just follow instructions in [terraform/azuredevops/](terraform/azuredevops/) folder.  :warning: This doesn't include creation of release pipeline as there is no REST API and Terraform resource for it.
2. manually - follow instructions below to create all necessary objects.


## Create necessary Databricks Repos checkouts

:construction: Work in progress...


## Create DLT pipelines

:construction: Work in progress...

## Create ADO build pipeline

:construction: Work in progress...

The ADO build pipeline consists of the two stages:

- `onPush` is executed on push to any Git branch except `releases` branch and version tags.  This stage only runs & reports unit tests results (both local & notebooks).
- `onRelease` is executed only on commits to the `releases` branch, and in addition to the unit tests it will execute a DLT pipeline with integration test (see image).

![Stages of ADO build pipeline](images/cicd-stages.png)



## Create ADO release pipeline

:construction: Work in progress...

