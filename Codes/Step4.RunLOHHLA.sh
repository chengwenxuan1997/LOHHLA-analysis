# for i in {2,6,10,11,12,14,16}
# for i in {2,3,4,6,7,8,9,10,11,12,14,16,18,19,20,23,25,29}
# for i in {15,21,22,28}
# for i in {2,3}
# for seuqenza with maximun SLPP
for i in {2,3,4,6,7,8,9,10,11,12,14,15,16,18,19,20,21,22,23,25,28,29}
do
{
  if [ -d patient${i}/LOHHLAoutputMax ];
  then rm -rf patient${i}/LOHHLAoutputMax
  fi
  mkdir patient${i}/LOHHLAoutputMax

  Rscript ~/data/cwx/LOHHLA/testa/preprocess.R patient${i} MaxSLPP

  rm -rf ~/data/cwx/LOHHLA/testa/patient${i}/LOHHLAoutputMax

  Rscript ~/data/cwx/LOHHLA/testa/LOHHLAscript.R \
  	--patientId patient${i} \
  	--outputDir ~/data/cwx/LOHHLA/testa/patient${i}/LOHHLAoutputMax \
  	--normalBAMfile ~/data/cwx/LOHHLA/testa/patient${i}/bam/Normal${i}.chr6.resorted.bam \
  	--tumorBAMfile ~/data/cwx/LOHHLA/testa/patient${i}/bam/Tumor${i}T.chr6.resorted.bam \
  	--BAMDir ~/data/cwx/LOHHLA/testa/patient${i}/bam  \
  	--hlaPath ~/data/cwx/LOHHLA/testa/patient${i}/hla \
  	--HLAfastaLoc ~/data/cwx/LOHHLA/test/public/abc_complete.fasta \
  	--HLAexonLoc ~/data/cwx/LOHHLA/test/public/hla.dat \
  	--CopyNumLoc ~/data/cwx/LOHHLA/testa/patient${i}/solutions.txt \
  	--mappingStep TRUE \
  	--minCoverageFilter 10 \
  	--fishingStep TRUE \
  	--cleanUp TRUE \
  	--gatkDir ~/miniconda3/share/picard-2.25.7-0 \
  	--novoDir /home/a207/miniconda3/bin \
  	--LOHHLA_loc ~/data/cwx/LOHHLA/testa \
   --jellyFish ~/home/a207/miniconda3/bin/jellyfish \
   --bedtools /usr/bin/bedtools \
   --samtools /usr/bin/samtools 

   Rscript ~/data/cwx/LOHHLA/testa/LOHHLAscript.R \
  	--patientId patient${i} \
  	--outputDir ~/data/cwx/LOHHLA/testa/patient${i}/LOHHLAoutputMax \
  	--normalBAMfile ~/data/cwx/LOHHLA/testa/patient${i}/bam/Normal${i}.chr6.resorted.bam \
  	--tumorBAMfile ~/data/cwx/LOHHLA/testa/patient${i}/bam/Tumor${i}T.chr6.resorted.bam \
  	--BAMDir ~/data/cwx/LOHHLA/testa/patient${i}/bam  \
  	--hlaPath ~/data/cwx/LOHHLA/testa/patient${i}/hla \
  	--HLAfastaLoc ~/data/cwx/LOHHLA/test/public/abc_complete.fasta \
  	--HLAexonLoc ~/data/cwx/LOHHLA/test/public/hla.dat \
  	--CopyNumLoc ~/data/cwx/LOHHLA/testa/patient${i}/solutions.txt \
  	--mappingStep TRUE \
  	--minCoverageFilter 3 \
  	--fishingStep TRUE \
  	--cleanUp TRUE \
  	--gatkDir ~/miniconda3/share/picard-2.25.7-0 \
  	--novoDir /home/a207/miniconda3/bin \
  	--LOHHLA_loc ~/data/cwx/LOHHLA/testa \
   --jellyFish ~/home/a207/miniconda3/bin/jellyfish \
   --bedtools /usr/bin/bedtools \
   --samtools /usr/bin/samtools
   
   Rscript ~/data/cwx/LOHHLA/testa/LOHHLAscript.R \
  	--patientId patient${i} \
  	--outputDir ~/data/cwx/LOHHLA/testa/patient${i}/LOHHLAoutputMax \
  	--normalBAMfile ~/data/cwx/LOHHLA/testa/patient${i}/bam/Normal${i}.chr6.resorted.bam \
  	--tumorBAMfile ~/data/cwx/LOHHLA/testa/patient${i}/bam/Tumor${i}T.chr6.resorted.bam \
  	--BAMDir ~/data/cwx/LOHHLA/testa/patient${i}/bam  \
  	--hlaPath ~/data/cwx/LOHHLA/testa/patient${i}/hla \
  	--HLAfastaLoc ~/data/cwx/LOHHLA/test/public/abc_complete.fasta \
  	--HLAexonLoc ~/data/cwx/LOHHLA/test/public/hla.dat \
  	--CopyNumLoc ~/data/cwx/LOHHLA/testa/patient${i}/solutions.txt \
  	--mappingStep TRUE \
  	--minCoverageFilter 5 \
  	--fishingStep TRUE \
  	--cleanUp TRUE \
  	--gatkDir ~/miniconda3/share/picard-2.25.7-0 \
  	--novoDir /home/a207/miniconda3/bin \
  	--LOHHLA_loc ~/data/cwx/LOHHLA/testa \
   --jellyFish ~/home/a207/miniconda3/bin/jellyfish \
   --bedtools /usr/bin/bedtools \
   --samtools /usr/bin/samtools
}
  	
done

# 2,3,4,6,7,8,9,10,11,12,14,15,16,18,19,20,21,22,23,25,28,29
