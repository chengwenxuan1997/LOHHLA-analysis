# LOHHLA-analysis-
a pipeline to run the LOHHLA analysis in automatically

The whole pipeline includes 
  * DNA sequences mapping (Step1.alignment.sh)  
  * HLA typing (Step2.polysolver.sh)  
  * tumor purity estimating (Step3.RunSequenza.sh)  
  * LOH calculation (Step4.RunLOHHLA.sh)  

The LOH calculation script was reworked by [slagtermaarten](https://github.com/slagtermaarten/LOHHLA), which uses the try-catch function to avoid endless warnings/errors in the [source code](https://github.com/mskcc/lohhla).
