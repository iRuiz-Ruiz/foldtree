# Setting the environment
#in whichever foldtree folder
#the factual beginning
```
mkdir datasets
mkdir jupyter-notebook
mkdir outputs
mkdir scripts

cd outputs

mkdir mining
cd mining
```

# Setting the space for the test
#change redor for other folder names
```
mkdir redo1
cd redo1

mkdir entries
mkdir phobius
mkdir uniprot
mkdir tree_metadata
```
### Execution of jupyter notebooks
```
cd redo1/entries 
```
#combine txt
```
find . -type f -name '*.txt' -exec cat {} + > combined.txt
wc -l combined.txt
```

#verify the number of values - should be the same as the total number of values
```
uniq -c combined.txt | wc -l
```
### get the sequences from uniprot

#phobius - need to be executed in the root 
## entering the root
```
cd 
sudo su
```
##pwd 
```
/mnt/c/Users/ek23810/'OneDrive - University of Bristol'/term2_project/foldtree_tidy/outputs/mining/redo1/phobius
```
##execute
```
perl /usr/local/share/phobius/phobius.pl -short /mnt/c/Users/ek23810/'OneDrive - University of Bristol'/term2_project/foldtree_tidy/outputs/mining/redo1/phobius/idmapping_2024_08_05.fasta > /mnt/c/Users/ek23810/'OneDrive - University of Bristol'/term2_project/foldtree_tidy/outputs/mining/redo1/phobius/phobius_output.txt

perl /usr/local/share/phobius/phobius.pl -short idmapping_2024_08_07.fasta > phobius_output.txt
```
### < ----------- short command version 
```
perl /usr/local/share/phobius/phobius.pl -short idmapping_2024_08_17.fasta > phobius_output.txt
```
##rename
```
sed -i 's/SEQENCE //g' phobius_output.txt
sed -E 's/[[:space:]]+/\t/g' phobius_output.txt > phobius_output_rn.txt
```
##Filtering
##### jupyter notebook execution 

### get entry list to uniprot - download dataset for cdhit

### <------------------ download the new set of sequences
### CD-HIT test #just to delete the equals
```
cd-hit -i idmapping_2024_08_19_phobius.fasta -o nr100 -c 1.00 -n 5 -M 200
```
### <----------------- run CD-HIT filtering in Jupyter Notebook and get the new datafile 
### run fold-tree

## FoldTree Run < -------- remember to change the folder name always 
```
nohup snakemake --cores 64 --use-conda -s ./workflow/fold_tree --config folder=./redo3-demendoza filter=False foldseek_cores=64 &
```
### < ------------ take a look into expassy
### < ------------ download the set of filtered sequences

### move the downloaded .fasta (uniprot) file to target_folder/tree/pfam
### rename the fasta file
```
sed 's/ .*//' idmapping_2024_08_21.fasta > idmap.fasta
```
## Pfam execution (Not executed) < ------- found specific domains
```
hmmsearch --cpu 8 -E 1e-10 --domtblout pfam.domtblout /home/raven/TransDecoder-TransDecoder-v5.7.1/Pfam-A.hmm idmapping_2024_07_21.fasta
```
