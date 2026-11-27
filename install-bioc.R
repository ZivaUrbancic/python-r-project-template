options(
    repos = c(CRAN = "https://cloud.r-project.org")
)

if (!requireNamespace("BiocManager", quietly = TRUE)) {
    install.packages("BiocManager")
}

BiocManager::install(
    c(
        "DESeq2",
        "GenomicRanges",
        "SummarizedExperiment",
        "ShortRead",
        "edgeR",
        "GenomicFeatures",
        "org.Dm.eg.db"
    ),
    ask = FALSE,
    update = FALSE
)
