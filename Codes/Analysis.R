path <- "~/data/cwx/LOHHLA/testa";setwd(path)
samples <- c(2,3,4,6,7,8,9,10,11,12,14,15,16,18,19,20,21,22,23,25,28,29)

#### clear unnecessary file
# lapply(samples, function(sample){
#   file.remove(paste0("patient", sample, "/Tumor", sample, "T.sam"))
#   file.remove(paste0("patient", sample, "/Tumor", sample, "T.bam"))
#   file.remove(paste0("patient", sample, "/Tumor", sample, "T.chr6.sorted.sam"))
#   file.remove(paste0("patient", sample, "/Tumor", sample, "T.chr6.sorted.bam"))
#   
#   file.remove(paste0("patient", sample, "/Normal", sample, ".sam"))
#   file.remove(paste0("patient", sample, "/Normal", sample, ".bam"))
#   file.remove(paste0("patient", sample, "/Normal", sample, ".chr6.sorted.sam"))
#   file.remove(paste0("patient", sample, "/Normal", sample, ".chr6.sorted.bam"))
# })

####sum the reads in hla region
CountHLAFromSam <- function(FileToRead){
  try <- c(read.delim(FileToRead, header = F, sep = "," ,row.names = NULL, nrows = 200))[[1]]
  lines <- max(which(substr(try, 1, 3) == "@PG"))
  # Header <- read.delim(FileToRead, header = F, sep = "," ,row.names = NULL, nrows = lines)
  seq <- read.delim(FileToRead, sep = "\t",header = F, row.names = NULL, skip = lines)
  seq <- subset(seq, V3 == "chr6")
  sum(sum(seq$V4 %in% 29909037:29913661),
      sum(seq$V4 %in% 31321649:31324964),
      sum(seq$V4 %in% 31236526:31239869))
}
NumHLAReads <- lapply(samples, function(sample){
  TumorFileName <- paste0("patient", sample, "/bam/Tumor", sample, "T.chr6.resorted.sam")
  TumorCount <- CountHLAFromSam(TumorFileName)
  NormalFileName <- paste0("patient", sample, "/bam/Normal", sample, ".chr6.resorted.sam")
  NormalCount <- CountHLAFromSam(NormalFileName)
  return(c(TumorCount, NormalCount))
})
NumHLAReads <- as.data.frame(do.call(rbind, NumHLAReads))
rownames(NumHLAReads) <- paste0("patient", samples)
colnames(NumHLAReads) <- c("Tumorcount", "Normalcount")


####hlatype(Normal)
hlatypes <- lapply(samples, function(sample){
  FileToRead <- paste0("patient", sample, "/polysolveroutput/winners.hla.nofreq.txt")
  if (file.exists(FileToRead)){
    hlatype <- read.table(FileToRead, row.names = 1)
    hlatype <- t(unlist(hlatype))
  }
})
hlatypes <- as.data.frame(do.call(rbind, hlatypes))
rownames(hlatypes) <- paste0("patient", samples)
colnames(hlatypes) <- c("hla_a1", "hla_b1", "hla_c1", "hla_a2", "hla_b2", "hla_c2")
hlatypes$hla_a = (hlatypes$hla_a1 != hlatypes$hla_a2)
hlatypes$hla_b = (hlatypes$hla_b1 != hlatypes$hla_b2)
hlatypes$hla_c = (hlatypes$hla_c1 != hlatypes$hla_c2)
hlatypes$summary = rowSums(cbind(hlatypes$hla_a, hlatypes$hla_b, hlatypes$hla_c))

####HLAType(Tumor)
Tumorhlatypes <- lapply(samples, function(sample){
  FileToRead <- paste0("patient", sample, "/polysolverToutput/winners.hla.nofreq.txt")
  if (file.exists(FileToRead)){
    hlatype <- read.table(FileToRead, row.names = 1)
    hlatype <- t(unlist(hlatype))
  }
})
Tumorhlatypes <- as.data.frame(do.call(rbind, Tumorhlatypes))
rownames(Tumorhlatypes) <- paste0("patient", samples)
colnames(Tumorhlatypes) <- c("hla_a1", "hla_b1", "hla_c1", "hla_a2", "hla_b2", "hla_c2")
Tumorhlatypes$hla_a = (Tumorhlatypes$hla_a1 != Tumorhlatypes$hla_a2)
Tumorhlatypes$hla_b = (Tumorhlatypes$hla_b1 != Tumorhlatypes$hla_b2)
Tumorhlatypes$hla_c = (Tumorhlatypes$hla_c1 != Tumorhlatypes$hla_c2)
Tumorhlatypes$summary = rowSums(cbind(Tumorhlatypes$hla_a, Tumorhlatypes$hla_b, Tumorhlatypes$hla_c))
compare <- hlatypes == Tumorhlatypes


####LOHHLAres
SortRes <- function(type, n){
  LOHHLAres <- lapply(samples, function(sample){
    FilePath <- paste0("patient", sample , "/LOHHLAoutput", type)
    FileToRead <- grep(paste0(n, ".DNA.HLAlossPrediction"), list.files(FilePath), value = T)
    if (!is.null(FileToRead)){
      File <- read.table(file.path(FilePath, FileToRead), header = T, sep = "\t")
    }else{print("no such file")}
  })
  names(LOHHLAres) <- paste0("patient", samples)
  table(unlist(lapply(LOHHLAres, length)))
  ColToAdd <- colnames(LOHHLAres[[1]])[4:39]
  LOHHLAres[unlist(lapply(LOHHLAres, length)) == 3 ][[1]][, ColToAdd] <- NA
  LOHHLAres <- do.call(rbind, LOHHLAres)
  # plot(density(LOHHLAres$PVal,na.rm = T))
  
  LOHHLAres <- list(
    "Abstract" = LOHHLAres[, c("message", "HLA_A_type1", "HLA_A_type2", "HLA_type1copyNum_withBAFBin", "HLA_type2copyNum_withBAFBin",
                               "PVal_unique", "LossAllele", "KeptAllele", "numMisMatchSitesCov", "propSupportiveSites")],
    "Detail" = LOHHLAres
  )
  openxlsx::write.xlsx(LOHHLAres, file = paste0("output/LOHHLAres", type, n, ".xlsx"), overwrite = T, row.names = T)
  # write.table(LOHHLAres$Detail, file = paste0("LOHHLAres", type, n, ".tsv"))
}

SortRes("Max", 10)
SortRes("Max", 5)
SortRes("Max", 3)
SortRes("Near", 10)
SortRes("Near", 5)
SortRes("Near", 3)
SortRes("MaxPair", 10)
SortRes("MaxPair", 5)
SortRes("MaxPair", 3)
SortRes("NearPair", 10)
SortRes("NearPair", 5)
SortRes("NearPair", 3)

# rownames(LOHHLAres) <- paste0("patient", sample)
rownames(LOHHLAres) <- c(2,"14a","14b")

save.image("AnalysisRes.RData")
