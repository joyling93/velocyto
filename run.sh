#!bin/bash
#--bam /PROJ/development/xiezhuoming/proj/velocyto/input/demo/seekone_demo/demo.bam \
#--filtered_barcode /PROJ/development/xiezhuoming/proj/velocyto/input/demo/seekone_demo/filtered_barcodes.tsv.gz \
source /PROJ/home/xiezhuoming/miniconda2/bin/activate /PROJ/home/xiezhuoming/miniconda2/envs/velocyto
Rscript ./bin/velocyto.prep.R \
--bam /PROJ/development/xiezhuoming/proj/velocyto/input/demo/10xdemo/outs/possorted_genome_bam.bam \
--filtered_barcode /PROJ/development/xiezhuoming/proj/velocyto/input/demo/10xdemo/outs/filtered_feature_bc_matrix/barcodes.tsv.gz \
--species human \
--add_tag F \
--outdir ./output \
--sample 10xdemo
