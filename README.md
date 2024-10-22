[![GitHub Actions CI Status](https://github.com/gallvp/prepngs/actions/workflows/ci.yml/badge.svg)](https://github.com/gallvp/prepngs/actions/workflows/ci.yml)
[![GitHub Actions Linting Status](https://github.com/gallvp/prepngs/actions/workflows/linting.yml/badge.svg)](https://github.com/gallvp/prepngs/actions/workflows/linting.yml)[![Cite with Zenodo](http://img.shields.io/badge/DOI-10.5281/zenodo.XXXXXXX-1073c8?labelColor=000000)](https://doi.org/10.5281/zenodo.XXXXXXX)
[![nf-test](https://img.shields.io/badge/unit_tests-nf--test-337ab7.svg)](https://www.nf-test.com)

[![Nextflow](https://img.shields.io/badge/nextflow%20DSL2-%E2%89%A523.04.0-23aa62.svg)](https://www.nextflow.io/)
[![run with conda](http://img.shields.io/badge/run%20with-conda-3EB049?labelColor=000000&logo=anaconda)](https://docs.conda.io/en/latest/)
[![run with docker](https://img.shields.io/badge/run%20with-docker-0db7ed?labelColor=000000&logo=docker)](https://www.docker.com/)
[![run with singularity](https://img.shields.io/badge/run%20with-singularity-1d355c.svg?labelColor=000000)](https://sylabs.io/docs/)
[![Launch on Seqera Platform](https://img.shields.io/badge/Launch%20%F0%9F%9A%80-Seqera%20Platform-%234256e7)](https://cloud.seqera.io/launch?pipeline=https://github.com/gallvp/prepngs)

## Introduction

**gallvp/prepngs** is a bioinformatics pipeline that pre-processes NGS data for downstream reuse across various pipelines.

```mermaid
%%{init: {
    'theme': 'base',
    'themeVariables': {
    'fontSize': '12px",
    'primaryColor': '#9A6421',
    'primaryTextColor': '#ffffff',
    'primaryBorderColor': '#9A6421',
    'lineColor': '#B180A8',
    'secondaryColor': '#455C58',
    'tertiaryColor': '#ffffff'
  }
}}%%

flowchart LR
  samplesheet(samplesheet.csv) ==> BAM2FASTQ
  samplesheet ==> FASTQC

  BAM2FASTQ ==> FASTQC
  FASTQC ==> FASTP
  FASTP ==> FASTQC2[FASTQC]

  FASTP ==> CAT
  CAT ==> FQ2FA

  CAT ==> fqout(FastQ)
  FQ2FA ==> faout(Fasta)

  FASTQC2 ==> multiqcout(MultiQC)

  subgraph Outputs[" "]
  multiqcout
  fqout
  faout
  end

  classDef bk fill:#0000
  class Outputs bk
```

1. BAM to FastQ ([`PBTK`](https://github.com/PacificBiosciences/pbtk), `optional`)
2. Raw read QC ([`FastQC`](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/))
3. Adapter trimming ([`FASTP`](https://github.com/OpenGene/fastp))
4. Trimmed read QC ([`FastQC`](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/))
5. Cat trimmed reads by group ([`cat`](https://www.linfo.org/cat.html), `optional`)
6. Convert trimmed reads to Fasta ([`Seqkit`](https://bioinf.shenwei.me/seqkit/), `optional`)
7. Present QC ([`MultiQC`](http://multiqc.info/))

## Usage

Refer to [usage](./docs/usage.md), [parameters](./docs/parameters.md) and [output](./docs/output.md) documents for details.

> [!NOTE]
> If you are new to Nextflow and nf-core, please refer to [this page](https://nf-co.re/docs/usage/installation) on how to set-up Nextflow. Make sure to [test your setup](https://nf-co.re/docs/usage/introduction#how-to-run-a-pipeline) with `-profile test` before running the workflow on actual data.

First, prepare a samplesheet with your input data that looks as follows:

**samplesheet.csv:**

```csv
sample,group,reads_1,reads_2
test1,,r1.fastq.gz,r2.fastq.gz
test2,group1,sampleA.ccs.bam
test3,group1,sampleC.ccs.bam
```

Each row represents a sample with a single fastq/bam file (single-end) or a pair of fastq files (paired end). `group` column is optional. When present, it is used to concatenate the samples.

> [!WARNING]
> Please provide pipeline parameters via the CLI or Nextflow `-params-file` option. Custom config files including those provided by the `-c` Nextflow option can be used to provide any configuration _**except for parameters**_; see [docs](https://nf-co.re/docs/usage/getting_started/configuration#custom-configuration-files).

Now, you can run the pipeline using:

```bash
nextflow run gallvp/prepngs \
   -profile <docker/singularity/.../institute> \
   --input samplesheet.csv \
   --outdir <OUTDIR>
```

### Plant&Food Users

Download the pipeline to your `/workspace/$USER` folder. Change the parameters defined in the [pfr/params.json](./pfr/params.json) file. Submit the pipeline to SLURM for execution.

```bash
sbatch ./pfr_prepngs
```

## Credits

gallvp/prepngs was originally written by Usman Rashid.

The pipeline uses nf-core modules contributed by following authors:

<a href="https://github.com/drpatelh"><img src="https://github.com/drpatelh.png" width="50" height="50"></a>
<a href="https://github.com/adamrtalbot"><img src="https://github.com/adamrtalbot.png" width="50" height="50"></a>
<a href="https://github.com/grst"><img src="https://github.com/grst.png" width="50" height="50"></a>
<a href="https://github.com/gallvp"><img src="https://github.com/gallvp.png" width="50" height="50"></a>
<a href="https://github.com/maxulysse"><img src="https://github.com/maxulysse.png" width="50" height="50"></a>
<a href="https://github.com/robsyme"><img src="https://github.com/robsyme.png" width="50" height="50"></a>
<a href="https://github.com/mbeavitt"><img src="https://github.com/mbeavitt.png" width="50" height="50"></a>
<a href="https://github.com/kevinmenden"><img src="https://github.com/kevinmenden.png" width="50" height="50"></a>
<a href="https://github.com/joseespinosa"><img src="https://github.com/joseespinosa.png" width="50" height="50"></a>
<a href="https://github.com/jfy133"><img src="https://github.com/jfy133.png" width="50" height="50"></a>
<a href="https://github.com/felixkrueger"><img src="https://github.com/felixkrueger.png" width="50" height="50"></a>
<a href="https://github.com/ewels"><img src="https://github.com/ewels.png" width="50" height="50"></a>
<a href="https://github.com/bunop"><img src="https://github.com/bunop.png" width="50" height="50"></a>
<a href="https://github.com/abhi18av"><img src="https://github.com/abhi18av.png" width="50" height="50"></a>
<a href="https://github.com/d-jch"><img src="https://github.com/d-jch.png" width="50" height="50"></a>

## Contributions and Support

If you would like to contribute to this pipeline, please see the [contributing guidelines](.github/CONTRIBUTING.md).

## Citations

<!-- TODO nf-core: Add citation for pipeline after first release. Uncomment lines below and update Zenodo doi and badge at the top of this file. -->
<!-- If you use gallvp/prepngs for your analysis, please cite it using the following doi: [10.5281/zenodo.XXXXXX](https://doi.org/10.5281/zenodo.XXXXXX) -->

An extensive list of references for the tools used by the pipeline can be found in the [`CITATIONS.md`](CITATIONS.md) file.

This pipeline uses code and infrastructure developed and maintained by the [nf-core](https://nf-co.re) community, reused here under the [MIT license](https://github.com/nf-core/tools/blob/master/LICENSE).

> **The nf-core framework for community-curated bioinformatics pipelines.**
>
> Philip Ewels, Alexander Peltzer, Sven Fillinger, Harshil Patel, Johannes Alneberg, Andreas Wilm, Maxime Ulysse Garcia, Paolo Di Tommaso & Sven Nahnsen.
>
> _Nat Biotechnol._ 2020 Feb 13. doi: [10.1038/s41587-020-0439-x](https://dx.doi.org/10.1038/s41587-020-0439-x).
