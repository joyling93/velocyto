#!bin/bash
source /PROJ/home/xiezhuoming/miniconda2/bin/activate /PROJ/home/xiezhuoming/miniconda2/envs/velocyto
Rscript ./bin/velocyto.plot.R \
--velocyto_rds /PROJ/development/xiezhuoming/proj/velocyto/pkg/output/demo/velocyto.rds \
--seurat_obj2project /PROJ/development/xiezhuoming/proj/velocyto/seektest/velocyto/test_seurat.rds \
--outdir ./output \
--gene2show CCNL2,SSU72,lala,GNB1
