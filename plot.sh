#!bin/bash
source /PROJ/development/xiezhuoming/soft/miniconda2/bin/activate /PROJ/development/xiezhuoming/soft/miniconda2/envs/velocyto
Rscript ./bin/velocyto.plot.R \
--velocyto_rds /PROJ/development/xiezhuoming/proj/velocyto/output/demo/velocyto.rds \
--seurat_obj2project /PROJ/development/xiezhuoming/proj/velocyto/input/demo/seekone_demo/demo_seurat.rds \
--outdir ./output \
--gene2show CCNL2,SSU72,errortest,GNB1
