library(Seurat)
library(velocyto.R)
library(argparse)
library(SeuratWrappers)

parser = ArgumentParser()
parser$add_argument("--bam", help="STAR比对后的 bam 格式文件。可在标准流程结果路径下，eg：alignmentYaml/SAMPLE/STAR/SAMPLE_SortedByCoordinate.bam（seekone）；cellrangerYaml/SAMPLE/out/possition_sorted.bam(10x)找到"
                    ,required=TRUE)
parser$add_argument("--filtered_barcode", help="初步过滤后的 barcodes 文件。可在在标准流程结果路径下，eg：countBarcodeYaml/SAMPLE/filtered_feature_bc_matrix/barcodes.tsv.gz（seekone）；cellrangerYaml/SAMPLE/out/filtered_feature_bc_matrix/barcodes.tsv.gz(10x)找到"
                    ,required=TRUE)
parser$add_argument("--species", help="目前支持 human|mouse|rat，可在./ref文件夹中自定义 gtf 文件，命名为 species_genes.gtf "
                    ,required=TRUE)
parser$add_argument("--add_tag", help="T|F，目前的 seekone 标准流程比对结果 bam 文件没有 CB\UB tag，选择 T 时会加上，10x 则不需要，使用没有相关 tag 的 bam 文件会报错。"
                    ,required=TRUE)
parser$add_argument("--outdir", help='默认是./output',required=TRUE,default="./output")
parser$add_argument("--sample", help="sample ID，需要唯一",required=TRUE)

args <- parser$parse_args()
str(args)

bam <- args$bam
filtered_barcode <- args$filtered_barcode
species<- args$species
add_tag<-args$add_tag
outdir<- file.path(args$outdir,args$sample)
ref <- file.path('./ref',paste0(species,'_genes.gtf'))

##加CB\UB tag
if(add_tag=='T')
        {
        shell_cmd <- paste('python bin/add_tag2bam.py --bam',bam,'--outdir',outdir,sep=' ')
        system(shell_cmd)
        taggedbam <- dir(outdir,'addtag.bam',full.names = T)
        if(length(dir(outdir,'.loom',full.names = T))==0){
                shell_cmd2 <- paste('velocyto run -b',filtered_barcode,'-o',outdir,taggedbam,ref,sep=' ')
                system(shell_cmd2)   
        }
}else {
        if(length(dir(outdir,'.loom',full.names = T))==0){
                shell_cmd2 <- paste('velocyto run -b',filtered_barcode,'-o',outdir,bam,ref,sep=' ')
                system(shell_cmd2)
        }
        }


loom_file <- dir(outdir,'.loom',full.names = T)
ldat <- ReadVelocity(file = loom_file)
bm <- as.Seurat(x = ldat)

#标准化细胞名称。velocyto会在 cell barcode两端添加额外字符，在下游分析前须去掉
bm <- RenameCells(bm,new.names=gsub('x','',gsub('.*:','',colnames(bm))))
saveRDS(bm,file.path(outdir,'velocyto.rds'))



