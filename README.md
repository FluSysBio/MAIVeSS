# Machine-learning Assisted Influenza VaccinE Strain Selection framework (MAIVeSS)
We present a computational method based on genome sequencing that enables rapid selection of an antigenically 33 matched and high-yield influenza vaccine strain directly from clinical samples.

# File structure
This repository contains four folders
1. Antigenicity learning
	- Serological data was collected from literatures, HA1 seuqences were collected from public databases (NCBI(https://www.ncbi.nlm.nih.gov/genomes/FLU/), GISAID (https://www.gisaid.org/) and Influenza Research Database (https://www.fludb.org/)) and N-linked glycosylation sites were predicted by NetNGlyc 1.0 Server (http://www.cbs.dtu.dk/services/NetNGlyc/).There are 8 tasks for training purpose.
	- 11424 seqeunces were collected from GISAID (https://www.gisaid.org/) with their accession number in fasta file for testing purpose.
2. Yield learning
	- Growth data was collected from our lab experiments (see Table S4) from both cell and egg.
	- 11424 seqeunces were collected from GISAID (https://www.gisaid.org/) with their accession number in fasta file for testing purpose.
3. GlycanBidning learning
	- binding data was collected from our lab experiments (see Table S4).
4. Prediction
	- The main function for predict antigenic distance and virus yield.

# Usage
1. Matlab enviroment required (R2019a under Windows). No extra toolbox requirment. 
2. Run MAIVeSS model using pre-processed data by Main.m in Antigenicity/Yield/GlycanBidning folder.
3. Run Prediction.m in Prediction folder to get predicted antigenic distance and virus yield.

## Feedback
Let me know if you have any questions or comments at chenggao@mail.missouri.edu or wanx@missouri.edu
