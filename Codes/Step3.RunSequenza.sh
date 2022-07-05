# for i in {2,3,4,6,7,8,9,10,11,12,14,15,16,18,19,20,21,22,23,25,28,29}
for i in {15,21,22,28}
do
{
  	mkdir patient${i}/sequenza
	echo sequenza for patient${i}
	sequenza-utils bam2seqz -n patient${i}/Normal${i}_CNV.bin.aligned.sorted.bam -t patient${i}/Tumor${i}T_CNV.bin.aligned.sorted.bam --fasta sequenza/hg19.fa -gc sequenza/hg19.gc50Base.wig.gz -o patient${i}/sequenza/out.seqz.gz
	sequenza-utils seqz_binning --seqz patient${i}/sequenza/out.seqz.gz -w 50 -o patient${i}/sequenza/small.seqz.gz
}&
done
#conda activate(tabix sequenza-utils)
#   i="15"
# 	mkdir patient${i}/sequenza
# 	echo sequenza for patient${i}
# 	/home/a207/miniconda3/bin/sequenza-utils bam2seqz -n patient${i}/Normal${i}_CNV.bin.aligned.sorted.bam -t patient${i}/Tumor${i}T_CNV.bin.aligned.sorted.bam --fasta sequenza/hg19.fa -gc sequenza/hg19.gc50Base.wig.gz -o patient${i}/sequenza/out.seqz.gz
# 	/home/a207/miniconda3/bin/sequenza-utils seqz_binning --seqz patient${i}/sequenza/out.seqz.gz -w 50 -o patient${i}/sequenza/small.seqz.gz