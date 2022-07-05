#for i in {2,6,10,11,14}
for i in {2,3,4,6,7,8,9,10,11,12,14,15,16,18,19,20,21,22,23,25,28,29}
do
docker run  -it --rm  -v ~/data/cwx/LOHHLA/testa/patient${i}:/home/analysis sachet/polysolver bash /home/polysolver/scripts/shell_call_hla_type /home/analysis/bam/Normal${i}.chr6.resorted.bam Unknown  0 hg19 STDFQ 0 /home/analysis/polysolveroutput
docker run  -it --rm  -v ~/data/cwx/LOHHLA/testa/patient${i}:/home/analysis sachet/polysolver bash /home/polysolver/scripts/shell_call_hla_type /home/analysis/bam/Tumor${i}T.chr6.resorted.bam Unknown  0 hg19 STDFQ 0 /home/analysis/polysolverToutput
done
