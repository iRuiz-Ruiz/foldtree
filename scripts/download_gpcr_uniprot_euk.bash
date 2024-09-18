#!/bin/bash
#new taxa - extending to the deep of eukarya

#Taxa_ID Group
#2759	Eukarya

taxa=("2759")

#PF00001	Rhodopsin
#PF00002	Adhesion/Secretin
#PF00003	Glutamate
#PF01534	Frizzled
#PF05462	cAMP
#PF12430	ABA
#PF11710	Git3
#PF02116	STE2	Not included
#PF02076	STE3	Not included
#PF02101	OA
#PF10192	ITR
#PF06814	GOST

my_list=("PF00001" "PF00002" "PF00003" "PF01534" "PF02076" "PF02101" "PF02116" "PF02117" "PF02118" "PF02175" "PF03006" "PF03125" "PF03383" "PF03402" "PF03619" "PF04080" "PF05296" "PF05462" "PF05875" "PF06454" "PF06814" "PF10192" "PF10292" "PF10316" "PF10317" "PF10318" "PF10319" "PF10320" "PF10321" "PF10322" "PF10323" "PF10324" "PF10325" "PF10326" "PF10327" "PF10328" "PF11710" "PF11970" "PF13853" "PF13965" "PF15100" "PF12430")

for out_item in "${taxa[@]}"
do
    echo "Downloading: $out_item"   
    # Loop through each value in the list and print it
    for item in "${my_list[@]}"
    do
        echo "Downloading: $item"

        #picking taxonomy filter
        url="https://rest.uniprot.org/uniprotkb/stream?compressed=true&fields=accession%2Creviewed%2Cid%2Cprotein_name%2Cgene_names%2Corganism_name%2Clength%2Cxref_alphafolddb%2Clineage%2Corganism_id&format=tsv&query=%28$item+AND+%28taxonomy_id%3A$out_item%29%29"
        output="uniprot-$item-$out_item.tsv.gz"

        curl -o $output $url
    done   
done
#gunzip *.gz
#wc -l *.tsv > summary.csv