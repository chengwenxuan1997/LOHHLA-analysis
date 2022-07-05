# Preparation befor LOHHLA
Args <- commandArgs(T)
# Args[1] <- "patient14"
# Args[2] <- "MaxSLPP"

# hlatype
FileToRead <- paste0(Args[1], "/polysolveroutput/winners.hla.nofreq.txt")
FileToWrite <- paste0(Args[1], "/hla")
# FileToRead <- "patient14/polysolveroutput/winners.hla.nofreq.txt"
# FileToWrite <- "patient14/test"
hlatype <- read.table(file = FileToRead, header = F, sep = "\t", row.names = 1)
hlatype <- unlist(hlatype)
write.table(hlatype, FileToWrite, row.names = F, col.names = F, quote = F)


# Tumor ploidy
FileToRead <- paste0("/home/a207/data/cwx/LOHHLA/test/", Args[1], "/sequenza/Test_alternative_solutions.txt")
# FileToWrite <- paste0(Args[1], "/solutions.txt")
ploidy <- read.table(FileToRead, header = T)
if (Args[2] == "MaxSLPP"){#select combination with maximum SLPP
  ploidy <- ploidy[which.min(ploidy$SLPP),]
  FileToWrite <- paste0(Args[1], "/solutionsMax.txt")
}else if(Args[2] == "Nearest"){# select combination whose ploidy is nearest to 2
  ploidy <- ploidy[which.min(abs(ploidy$ploidy-2)),]
  FileToWrite <- paste0(Args[1], "/solutionsNear.txt")
}
ploidy <- ploidy[which.min(ploidy$SLPP),]
ploidy <- data.frame(
  row.names = paste0("Tumor", unlist(strsplit(Args, "t"))[3], "T.chr6.resorted"),
  Ploidy = 2,
  tumorPurity = ploidy$cellularity,
  tumorPloidy	= ploidy$ploidy
)
write.table(ploidy, FileToWrite, row.names = T, col.names = T, quote = F, sep = "\t")
