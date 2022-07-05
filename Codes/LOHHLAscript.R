#!/usr/bin/env Rscript

library(optparse)

option_list = list(
  make_option(c("--patientId"), type="character", default=NULL,
              help="patient ID", metavar="character"),
  make_option(c("--outputDir"), type="character", default=NULL,
              help="location of output directory", metavar="character"),
  make_option(c("--tumorBAMfile"), type="character", default=NULL,
              help="tumor BAM file", metavar="character"),
  make_option(c("--normalBAMfile"), type="character", default=NULL,
              help="normal BAM file\n\t\tcan be FALSE to run without normal sample", metavar="character"),
  make_option(c("--BAMDir"), type="character", default=NULL,
              help="location of all BAMs to test", metavar="character"),
  make_option(c("--hlaPath"), type="character", default=NULL,
              help="location to patient HLA calls", metavar="character"),
  make_option(c("--HLAfastaLoc"), type="character", 
                default='~/lohhla/data/hla_all.fasta',
                help="location of HLA FASTA [default= %default]", 
                metavar="character"),
  make_option(c('--LOHHLA_loc'), type='character', 
                default='~/libs/LOHHLA',
                help='location of LOHHLA R library [default= %default]', 
                metavar='character'),
  make_option(c("--CopyNumLoc"), type="character", default="FALSE",
              help="location to patient purity and ploidy output\n\t\tcan be FALSE to only estimate allelic imbalance", metavar="character"),
  make_option(c("--overrideDir"), type="character", default='FALSE',
              help="location of flagstat information if already run [default= %default]", metavar="character"),
  make_option(c("--minCoverageFilter"), type="numeric", default=30,
              help="minimum coverage at mismatch site [default= %default]", metavar="character"),
  make_option(c("--normalAlignedReads"), type="numeric", default=NULL,
              help="Number of aligned reads to the normal sample, will be
              inferred if omitted [default= %default]", metavar="character"),
  make_option(c("--tumorAlignedReads"), type="numeric", default=NULL,
              help="Number of aligned reads to the tumor sample, will be
              inferred if omitted [default= %default]", metavar="character"),
  make_option(c("--kmerSize"), type="numeric", default=50,
              help="size of kmers to fish with [default= %default]", metavar="character"),
  make_option(c("--numMisMatch"), type="numeric", default=1,
              help="number of mismatches allowed in read to map to HLA allele [default= %default]", metavar="character"),
  make_option(c("--mappingStep"), type="logical", default=TRUE,
              help="does mapping to HLA alleles need to be done [default= %default]", metavar="character"),
  make_option(c("--fishingStep"), type="logical", default=TRUE,
              help="if mapping is performed, also look for fished reads matching kmers of size kmerSize [default= %default]", metavar="character"),
  make_option(c("--plottingStep"), type="logical", default=FALSE,
              help="are plots made [default= %default]", metavar="character"),
  make_option(c("--coverageStep"), type="logical", default=TRUE,
              help="are coverage differences analyzed [default= %default]", metavar="character"),
  make_option(c("--cleanUp"), type="logical", default=F,
              help="remove temporary files [default= %default]", metavar="character"),
  make_option(c("--novoDir"), type="character", default='',
              help="path to novoalign executable [default= %default]", metavar="character"),
  make_option(c("--novoThreads"), type="integer", default=min(as.integer(system('nproc', intern = T)), 8),
              help="amount of threads to be used by novoalign [default= %default]", metavar="character"),
  make_option(c("--gatkDir"), type="character", default='',
              help="path to GATK executable [default= %default]", metavar="character"),
  make_option(c("--HLAexonLoc"), type="character", default='~/lohhla/data/hla.dat',
              help="HLA exon boundaries for plotting [default= %default]", metavar="character"),
  make_option(c("--ignoreWarnings"), type="logical", default=TRUE,
              help="continue running with warnings [default= %default]", metavar="character"),
  make_option(c("--genomeAssembly"), type="character", default='hg19',
              help="specify genome assembly (hg19 or grch38) [default= %default]", metavar="character"),
  make_option(c("--jellyFish"), type="character", default='jellyfish',
              help="specify location of jellyfish binary", metavar="character"),
  make_option(c("--bedtools"), type="character", default='bedtools',
              help="specify location of bedtools binary", metavar="character"),
  make_option(c('--fnExt'), type='character', default='',
              help='Extension to append to output file', metavar='character'),
  make_option(c('--samtools'), type='character', default='samtools',
              help='specify location of samtools binary', metavar='character'),
  make_option(c('--forceRedo'), type='logical', default=F,
              help='Whether to repeat mapping step even though the mapped files are already present', 
              metavar='character'),
  make_option(c('--requirePairedReads'), type='logical', default=TRUE,
              help='whether to require reads to paired, ignored if single-end sequencing is detected', 
              metavar='character'),
  make_option(c('--adaptBinSize'), type='logical', default=TRUE,
              help='whether to adapt bin size to the amount of mismatch sites to
              evaluate CN ratios over, not included in original LOHHLA', 
              metavar='character'),
  make_option(c('--checkIndices'), type='logical', default=TRUE,
              help='whether to restrict allelic coverage comparison to sites
              that are covered in both samples, not included in original LOHHLA', 
              metavar='character')
)

opt_parser <- OptionParser(option_list=option_list)
opt <- parse_args(opt_parser)

# opt$patientId="patient2"
# opt$outputDir="~/data/cwx/LOHHLA/testa/patient2/LOHHLAoutputc"
# # opt$normalBAMfile="~/data/cwx/LOHHLA/test/patient6/Normal6_CNV.bin.aligned.sorted.bam"
# # opt$BAMDir="~/data/cwx/LOHHLA/test/patient6"
# opt$normalBAMfile="~/data/cwx/LOHHLA/testa/patient2/bam/Normal2.chr6.resorted.bam"
# opt$tumorBAMfile="~/data/cwx/LOHHLA/testa/patient2/bam/Tumor2T.chr6.resorted.bam"
# opt$BAMDir="~/data/cwx/LOHHLA/testa/patient2/bam"
# opt$hlaPath="~/data/cwx/LOHHLA/testa/patient2/hla"
# # opt$HLAfastaLoc="~/data/cwx/LOHHLA/test/public/hla_reference_dna.fasta"
# opt$HLAfastaLoc="~/data/cwx/LOHHLA/test/public/abc_complete.fasta"
# # opt$HLAfastaLoc="~/data/cwx/LOHHLA/testa/patient2/patient2.fasta"
# # opt$HLAfastaLoc="~/data/cwx/LOHHLA/test/patient6/refer.fa"
# opt$HLAexonLoc="~/data/cwx/LOHHLA/lohhla/data/hla.dat"
# # opt$HLAexonLoc="~/data/cwx/LOHHLA/test/public/hla.dat"
# opt$CopyNumLoc="~/data/cwx/LOHHLA/testa/patient2/solutions.txt"
# opt$mappingStep=TRUE
# opt$minCoverageFilter=3
# opt$fishingStep=TRUE
# opt$cleanUp=FALSE
# opt$gatkDir="~/miniconda3/share/picard-2.25.7-0"
# opt$novoDir <- "/home/a207/miniconda3/bin"
# opt$LOHHLA_loc <- "~/data/cwx/LOHHLA/testa"
# opt$jellyFish <- "/home/a207/miniconda3/bin/jellyfish"
# opt$bedtools <- "/usr/bin/bedtools"
# opt$samtools <- "/usr/bin/samtools"
# opt$forceRedo <- TRUE

opt$patientId="example"
opt$outputDir="~/data/cwx/LOHHLA/testa/test/test20"
opt$normalBAMfile="~/data/cwx/LOHHLA/test/patient6/Normal6_CNV.bin.aligned.sorted.bam"
opt$BAMDir="~/data/cwx/LOHHLA/test/patient6"
opt$normalBAMfile="~/data/cwx/LOHHLA/lohhla/example-file/bam/example_BS_GL_sorted.bam"
opt$tumorBAMfile="~/data/cwx/LOHHLA/lohhla/example-file/bam/example_tumor_sorted.bam"
opt$BAMDir="~/data/cwx/LOHHLA/lohhla/example-file/bam"
opt$hlaPath="~/data/cwx/LOHHLA/lohhla/example-file/hlas"
opt$HLAfastaLoc="~/data/cwx/LOHHLA/lohhla/data/example.patient.hlaFasta.fa"
opt$HLAfastaLoc="~/data/cwx/LOHHLA/test/public/abc_complete.fasta"
opt$HLAexonLoc="~/data/cwx/LOHHLA/lohhla/data/hla.dat"
# opt$HLAexonLoc="~/data/cwx/LOHHLA/test/public/hla.dat"
opt$CopyNumLoc="~/data/cwx/LOHHLA/lohhla/example-file/solutions.txt"
opt$mappingStep=TRUE
opt$minCoverageFilter=10
opt$fishingStep=TRUE
opt$cleanUp=FALSE
opt$gatkDir="~/miniconda3/share/picard-2.25.7-0"
opt$novoDir <- "/home/a207/miniconda3/bin"
opt$LOHHLA_loc <- "~/data/cwx/LOHHLA/testa"
opt$jellyFish <- "/home/a207/miniconda3/bin/jellyfish"
opt$bedtools <- "/usr/bin/bedtools"
opt$samtools <- "/usr/bin/samtools"
# opt$plottingStep <- T



## TODO infer this automatically or just configure in a package
if (!dir.exists(opt$LOHHLA_loc)) {
  stop('LOHHLA_loc command line argument seems to be incorrect')
}
source(file.path(opt$LOHHLA_loc, 'functions.R'))

# strip trailing / from all parameters in opt
for (i in 1:length(opt)) {
  if (substr(opt[i], nchar(opt[i]), nchar(opt[i])) == '/') {
    opt[i] <- substr(opt[i], 1, nchar(opt[i]) - 1)
  }
}

run_LOHHLA(opt)
