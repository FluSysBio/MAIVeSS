# Machine-learning Assisted Influenza VaccinE Strain Selection framework (MAIVeSS)
We present a computational method based on genome sequencing that enables rapid selection of an antigenically matched and high-yield influenza vaccine strain directly from clinical samples.

# File structure
This repository contains five folders
1. Training and testing code for all the methods metioned in the paper which includes 10-fold cross validation.
  - AntCode folder has all the necessary code for antigenicity analysis in the paper.
  - YieCode folder has all the necessary code for yield analysis in the paper.
  - GlyCode folder has all the necessary code for glycan binding analysis in the paper.
2. Antigenicity model
  - Serological data was collected from literatures, HA1 seuqences were collected from public databases (NCBI(https://www.ncbi.nlm.nih.gov/genomes/FLU/), GISAID (https://www.gisaid.org/) and Influenza Research Database (https://www.fludb.org/)) and N-linked glycosylation sites were predicted by NetNGlyc 1.0 Server (http://www.cbs.dtu.dk/services/NetNGlyc/).There are 8 tasks for training purpose.
  - 11424 seqeunces were collected from GISAID (https://www.gisaid.org/) with their accession number in fasta file for testing purpose.
3. Yield model
  - Growth data was collected from our lab experiments (see Table S4) from both cell and egg for training purpose.
  - 11424 seqeunces were collected from GISAID (https://www.gisaid.org/) with their accession number in fasta file for testing purpose.
4. Glycan Bidning model
  - binding data was collected from our lab experiments (see Table S4) for training purpose.
5. Prediction model
  - The main function for predict antigenic distance and virus yield.

# Usage
1. Matlab enviroment required (version R2023a or under on a Windows system). No extra toolbox requirment. 
2. Run MAIVeSS 10-fold cross validation model using pre-processed data by Main10fold.m in AntCode/YCode/GlyCode folder (training).
3. Run MAIVeSS testing model using pre-processed data by MainTesting.m in AntCode/YCode/GlyCode folder (testing).
4. Run Prediction.m in Prediction folder to get predicted antigenic distance and virus yield (Prediction).

## Feedback
Let me know if you have any questions or comments at chenggao@mail.missouri.edu or wanx@missouri.edu