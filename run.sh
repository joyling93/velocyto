#!bin/bash
source /PROJ/home/xiezhuoming/miniconda2/bin/activate /PROJ/home/xiezhuoming/miniconda2/envs/velocyto
Rscript ./bin/velocyto.prep.R \
--bam /PROJ/development/xiezhuoming/proj/velocyto/input/demo/seekone_demo/demo.bam \
--filtered_barcode /PROJ/development/xiezhuoming/proj/velocyto/input/demo/seekone_demo/filtered_barcodes.tsv.gz \
--species human \
--add_tag F \
--outdir ./output \
--sample demo
