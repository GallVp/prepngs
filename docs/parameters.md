# gallvp/prepngs pipeline parameters

A pipeline to pre-process raw NGS data for downstream reuse across various pipelines

## Input/output options

Define where the pipeline should find input data and save output data.

| Parameter       | Description                                                                                                              | Type      | Default | Required | Hidden |
| --------------- | ------------------------------------------------------------------------------------------------------------------------ | --------- | ------- | -------- | ------ |
| `input`         | Path to comma-separated file containing information about the samples in the experiment.                                 | `string`  |         | True     |        |
| `cat_by_group`  | Concatenate samples by group                                                                                             | `boolean` | True    |          |        |
| `outdir`        | The output directory where the results will be saved. You have to use absolute paths to storage on Cloud infrastructure. | `string`  |         | True     |        |
| `email`         | Email address for completion summary.                                                                                    | `string`  |         |          |        |
| `multiqc_title` | MultiQC report title. Printed as page header, used for filename if not otherwise specified.                              | `string`  |         |          |        |

## Trimming options

| Parameter             | Description                                                                              | Type      | Default                             | Required | Hidden |
| --------------------- | ---------------------------------------------------------------------------------------- | --------- | ----------------------------------- | -------- | ------ |
| `skip_trimming`       | Skip adapter trimming step                                                               | `boolean` |                                     |          |        |
| `save_trimmed_fail`   | Save the trimmed FastQ files in the results directory                                    | `boolean` | True                                |          |        |
| `min_trimmed_reads`   | Minimum number of trimmed reads below which samples are removed from further processing  | `integer` | 10000                               |          |        |
| `additional_adapters` | Fasta file containing additional adapter for trimming                                    | `string`  | ${projectDir}/assets/adapters.fasta |          |        |
| `extra_fastp_args`    | Extra arguments to pass to fastp command in addition to defaults defined by the pipeline | `string`  |                                     |          |        |

## Institutional config options

Parameters used to describe centralised config profiles. These should not be edited.

| Parameter                    | Description                               | Type     | Default                                                  | Required | Hidden |
| ---------------------------- | ----------------------------------------- | -------- | -------------------------------------------------------- | -------- | ------ |
| `custom_config_version`      | Git commit id for Institutional configs.  | `string` | master                                                   |          | True   |
| `custom_config_base`         | Base directory for Institutional configs. | `string` | https://raw.githubusercontent.com/nf-core/configs/master |          | True   |
| `config_profile_name`        | Institutional config name.                | `string` |                                                          |          | True   |
| `config_profile_description` | Institutional config description.         | `string` |                                                          |          | True   |
| `config_profile_contact`     | Institutional config contact information. | `string` |                                                          |          | True   |
| `config_profile_url`         | Institutional config URL link.            | `string` |                                                          |          | True   |

## Max job request options

Set the top limit for requested resources for any single job.

| Parameter    | Description                                                        | Type      | Default | Required | Hidden |
| ------------ | ------------------------------------------------------------------ | --------- | ------- | -------- | ------ |
| `max_cpus`   | Maximum number of CPUs that can be requested for any single job.   | `integer` | 12      |          | True   |
| `max_memory` | Maximum amount of memory that can be requested for any single job. | `string`  | 72.GB   |          | True   |
| `max_time`   | Maximum amount of time that can be requested for any single job.   | `string`  | 12.h    |          | True   |

## Generic options

Less common options for the pipeline, typically set in a config file.

| Parameter                          | Description                                                                                  | Type      | Default                                                  | Required | Hidden |
| ---------------------------------- | -------------------------------------------------------------------------------------------- | --------- | -------------------------------------------------------- | -------- | ------ |
| `help`                             | Display help text.                                                                           | `boolean` |                                                          |          | True   |
| `version`                          | Display version and exit.                                                                    | `boolean` |                                                          |          | True   |
| `publish_dir_mode`                 | Method used to save pipeline results to output directory.                                    | `string`  | copy                                                     |          | True   |
| `email_on_fail`                    | Email address for completion summary, only when pipeline fails.                              | `string`  |                                                          |          | True   |
| `plaintext_email`                  | Send plain-text email instead of HTML.                                                       | `boolean` |                                                          |          | True   |
| `max_multiqc_email_size`           | File size limit when attaching MultiQC reports to summary emails.                            | `string`  | 25.MB                                                    |          | True   |
| `monochrome_logs`                  | Do not use coloured log outputs.                                                             | `boolean` |                                                          |          | True   |
| `monochromeLogs`                   | Do not use coloured log outputs.                                                             | `boolean` |                                                          |          | True   |
| `hook_url`                         | Incoming hook URL for messaging service                                                      | `string`  |                                                          |          | True   |
| `multiqc_config`                   | Custom config file to supply to MultiQC.                                                     | `string`  |                                                          |          | True   |
| `multiqc_logo`                     | Custom logo file to supply to MultiQC. File name must also be set in the MultiQC config file | `string`  |                                                          |          | True   |
| `multiqc_methods_description`      | Custom MultiQC yaml file containing HTML including a methods description.                    | `string`  |                                                          |          |        |
| `validate_params`                  | Boolean whether to validate parameters against the schema at runtime                         | `boolean` | True                                                     |          | True   |
| `validationShowHiddenParams`       | Show all params when using `--help`                                                          | `boolean` |                                                          |          | True   |
| `validationFailUnrecognisedParams` | Validation of parameters fails when an unrecognised parameter is found.                      | `boolean` |                                                          |          | True   |
| `validationLenientMode`            | Validation of parameters in lenient more.                                                    | `boolean` |                                                          |          | True   |
| `pipelines_testdata_base_path`     | Base URL or local path to location of pipeline test dataset files                            | `string`  | https://raw.githubusercontent.com/nf-core/test-datasets/ |          | True   |
