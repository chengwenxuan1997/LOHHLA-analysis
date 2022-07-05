#for i in {2,6,10,11,14}
for i in {3,4,7,8,9,12,15,16,18,19,20,21,22,23,25,28,29}
do
	bwa mem -t 20 -R '@RG\tID:Tumor${i}T\tSM:Tumor${i}T\tLB:Tumor${i}T\tCN:orient\tPL:illumina' hg19.fa patient${i}/Tumor${i}T_1.fq.gz patient${i}/Tumor${i}T_2.fq.gz -o patient${i}/Tumor${i}T.sam
	samtools view -bh patient${i}/Tumor${i}T.sam > patient${i}/Tumor${i}T.bam
	samtools sort -@ 20 -o patient${i}/Tumor${i}T.sorted.bam patient${i}/Tumor${i}T.bam
	samtools index patient${i}/Tumor${i}T.sorted.bam
	rm -rf patient${i}/bam
	mkdir patient${i}/bam
	samtools view -H patient${i}/Tumor${i}T.sorted.bam >  patient${i}/Tumor${i}T.chr6.sorted.sam
	samtools view  patient${i}/Tumor${i}T.sorted.bam chr6 >>  patient${i}/Tumor${i}T.chr6.sorted.sam
	samtools view  patient${i}/Tumor${i}T.sorted.bam chr6_ssto_hap7 >>  patient${i}/Tumor${i}T.chr6.sorted.sam
	samtools view  patient${i}/Tumor${i}T.sorted.bam chr6_mcf_hap5 >>  patient${i}/Tumor${i}T.chr6.sorted.sam
	samtools view  patient${i}/Tumor${i}T.sorted.bam chr6_cox_hap2>>  patient${i}/Tumor${i}T.chr6.sorted.sam
	samtools view  patient${i}/Tumor${i}T.sorted.bam chr6_mann_hap4 >>  patient${i}/Tumor${i}T.chr6.sorted.sam
	samtools view  patient${i}/Tumor${i}T.sorted.bam chr6_apd_hap1 >>  patient${i}/Tumor${i}T.chr6.sorted.sam
	samtools view  patient${i}/Tumor${i}T.sorted.bam chr6_qbl_hap6 >>  patient${i}/Tumor${i}T.chr6.sorted.sam
	samtools view  patient${i}/Tumor${i}T.sorted.bam chr6_dbb_hap3 >>  patient${i}/Tumor${i}T.chr6.sorted.sam
	samtools view -bh  patient${i}/Tumor${i}T.chr6.sorted.sam > patient${i}/Tumor${i}T.chr6.sorted.bam
	samtools sort -@ 20 -o patient${i}/bam/Tumor${i}T.chr6.resorted.bam patient${i}/Tumor${i}T.chr6.sorted.bam
	samtools index patient${i}/bam/Tumor${i}T.chr6.resorted.bam
	samtools view -h patient${i}/bam/Tumor${i}T.chr6.resorted.bam > patient${i}/bam/Tumor${i}T.chr6.resorted.sam 

	bwa mem -t 20 -R '@RG\tID:Normal${i}\tSM:Normal${i}\tLB:Normal${i}\tCN:orient\tPL:illumina' hg19.fa patient${i}/Normal${i}_1.fq.gz patient${i}/Normal${i}_2.fq.gz -o patient${i}/Normal${i}.sam
	samtools view -bh patient${i}/Normal${i}.sam > patient${i}/Normal${i}.bam
	samtools sort -@ 20 -o patient${i}/Normal${i}.sorted.bam patient${i}/Normal${i}.bam
	samtools index patient${i}/Normal${i}.sorted.bam
	samtools view -H patient${i}/Normal${i}.sorted.bam >  patient${i}/Normal${i}.chr6.sorted.sam
	samtools view  patient${i}/Normal${i}.sorted.bam chr6 >>  patient${i}/Normal${i}.chr6.sorted.sam
	samtools view  patient${i}/Normal${i}.sorted.bam chr6_ssto_hap7 >>  patient${i}/Normal${i}.chr6.sorted.sam
	samtools view  patient${i}/Normal${i}.sorted.bam chr6_mcf_hap5 >>  patient${i}/Normal${i}.chr6.sorted.sam
	samtools view  patient${i}/Normal${i}.sorted.bam chr6_cox_hap2>>  patient${i}/Normal${i}.chr6.sorted.sam
	samtools view  patient${i}/Normal${i}.sorted.bam chr6_mann_hap4 >>  patient${i}/Normal${i}.chr6.sorted.sam
	samtools view  patient${i}/Normal${i}.sorted.bam chr6_apd_hap1 >>  patient${i}/Normal${i}.chr6.sorted.sam
	samtools view  patient${i}/Normal${i}.sorted.bam chr6_qbl_hap6 >>  patient${i}/Normal${i}.chr6.sorted.sam
	samtools view  patient${i}/Normal${i}.sorted.bam chr6_dbb_hap3 >>  patient${i}/Normal${i}.chr6.sorted.sam
	samtools view -bh  patient${i}/Normal${i}.chr6.sorted.sam > patient${i}/Normal${i}.chr6.sorted.bam
	samtools sort -@ 20 -o patient${i}/bam/Normal${i}.chr6.resorted.bam patient${i}/Normal${i}.chr6.sorted.bam
	samtools index patient${i}/bam/Normal${i}.chr6.resorted.bam
	samtools view -h patient${i}/bam/Normal${i}.chr6.resorted.bam > patient${i}/bam/Normal${i}.chr6.resorted.sam 
done
