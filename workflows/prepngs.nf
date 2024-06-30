/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    IMPORT MODULES / SUBWORKFLOWS / FUNCTIONS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/
include { MULTIQC                           } from '../modules/nf-core/multiqc/main'
include { paramsSummaryMap                  } from 'plugin/nf-validation'
include { paramsSummaryMultiqc              } from '../subworkflows/nf-core/utils_nfcore_pipeline'
include { softwareVersionsToYAML            } from '../subworkflows/nf-core/utils_nfcore_pipeline'
include { methodsDescriptionText            } from '../subworkflows/local/utils_nfcore_prepngs_pipeline'

include { FASTQ_FASTQC_UMITOOLS_FASTP       } from '../subworkflows/nf-core/fastq_fastqc_umitools_fastp/main'

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    RUN MAIN WORKFLOW
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

workflow PREPNGS {

    take:
    ch_samplesheet                          // channel: samplesheet read in from --input

    main:

    ch_versions                             = Channel.empty()
    ch_multiqc_files                        = Channel.empty()
    ch_multiqc_extra_files                  = Channel.empty()
    ch_multiqc_reports                      = Channel.empty()

    // SUBSORKFLOW: FASTQ_FASTQC_UMITOOLS_FASTP
    FASTQ_FASTQC_UMITOOLS_FASTP (
        ch_samplesheet,
        false,                              // skip_fastqc
        false,                              // with_umi
        true,                               // skip_umi_extract
        0,                                  // umi_discard_read
        params.skip_trimming,
        [],                                 // adapter_fasta,
        params.save_trimmed_fail,
        false,                              // save_merged
        params.min_trimmed_reads
    )

    ch_multiqc_files                        = ch_multiqc_files
                                            | mix(FASTQ_FASTQC_UMITOOLS_FASTP.out.fastqc_raw_zip)
                                            | mix(FASTQ_FASTQC_UMITOOLS_FASTP.out.trim_json)
                                            | mix(FASTQ_FASTQC_UMITOOLS_FASTP.out.fastqc_trim_zip)

    ch_versions                             = ch_versions.mix(FASTQ_FASTQC_UMITOOLS_FASTP.out.versions)

    //
    // Collate and save software versions
    //
    softwareVersionsToYAML ( ch_versions )
    | collectFile(
        storeDir: "${params.outdir}/pipeline_info",
        name: 'nf_core_pipeline_software_mqc_versions.yml',
        sort: true,
        newLine: true
    )
    | set { ch_collated_versions }

    // MODULE: MultiQC
    ch_multiqc_config                       = params.multiqc_config
                                            ? Channel.fromPath(params.multiqc_config, checkIfExists: true)
                                            : Channel.fromPath("$projectDir/assets/multiqc_config.yml", checkIfExists: true)

    ch_multiqc_logo                         = params.multiqc_logo
                                            ? Channel.fromPath(params.multiqc_logo, checkIfExists: true)
                                            : Channel.empty()

    summary_params                          = paramsSummaryMap(workflow, parameters_schema: "nextflow_schema.json")

    ch_workflow_summary                     = Channel.value(paramsSummaryMultiqc(summary_params))

    ch_multiqc_custom_methods_description   = params.multiqc_methods_description
                                            ? file(params.multiqc_methods_description, checkIfExists: true)
                                            : file("$projectDir/assets/methods_description_template.yml", checkIfExists: true)

    ch_methods_description                  = Channel.value(methodsDescriptionText(ch_multiqc_custom_methods_description))

    ch_multiqc_extra_files                  = ch_multiqc_extra_files
                                            | mix(
                                                ch_workflow_summary
                                                | collectFile(name: 'workflow_summary_mqc.yaml')
                                            )

    ch_multiqc_extra_files                  = ch_multiqc_extra_files
                                            | mix(ch_collated_versions)

    ch_multiqc_extra_files                  = ch_multiqc_extra_files
                                            | mix(
                                                ch_methods_description
                                                | collectFile(name: 'methods_description_mqc.yaml', sort: true)
                                            )

    MULTIQC (
        ch_multiqc_files.map { meta, file -> file }.mix(ch_multiqc_extra_files).collect(),
        ch_multiqc_config.toList(),
        Channel.empty().toList(),
        ch_multiqc_logo.toList()
    )

    emit:
    multiqc_report                          = MULTIQC.out.report.toList()    // channel: /path/to/multiqc_report.html
}

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    THE END
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/
