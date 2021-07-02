library(Seurat)
library(velocyto.R)
library(argparse)

parser = ArgumentParser()

parser$add_argument("--velocyto_rds", help="包含 4 个 assay 的 seurat 对象（velocyto.rds）。可在 velocyto.prep.R 的结果文件中找到。"
                    ,required=TRUE)
parser$add_argument("--seurat_obj2project", help="用于画图的 seurat 对象，rds格式。eg：basicSeuratYaml/SAMPLE/SAMPLE_seurat.rds。"
                    ,required=TRUE)
parser$add_argument("--outdir", help="输出文件路径，默认是./output。"
                    ,default='./output')
parser$add_argument("--reduction_space", help="seurat_obj 的降维空间，默认是 umap。"
                    ,default='umap')
parser$add_argument("--default_assay", help="seurat_obj 的 default_assay，默认是 RNA。"
                    ,default='RNA')
parser$add_argument("--gene2show", help="需要画图的基因列表，多个基因可以,分隔，没有 fit 出 γ 值的基因不会出出图。",default=NULL)
parser$add_argument("--n.cores", help="需求核数，默认是 1。",default=1)


args <- parser$parse_args()
str(args)
velocyto_rds <- args$velocyto_rds
seurat_obj2project <- args$seurat_obj2project
outdir <- args$outdir
reduction_space <- args$reduction_space
gene2show<-strsplit(args$gene2show,',')[[1]]
default_assay <- args$default_assay
n.cores <- args$n.cores

##获取已经聚类的seurat对象
obj<-readRDS(seurat_obj2project)
DefaultAssay(obj)<-default_assay
#获取seurat对象umap坐标
embs<-Embeddings(obj, reduction = reduction_space)
#获取seurat对象分类
ident.colors <- (scales::hue_pal())(n = length(x = levels(x = obj)))
names(x = ident.colors) <- levels(x = obj)
cell.colors <- ident.colors[Idents(object = obj)]
names(x = cell.colors) <- colnames(x = obj)

##获取对应velocyto文件
bm<-readRDS(velocyto_rds)
#统一细胞数
bm <- subset(x = bm, cells = colnames(obj))
# exonic read (spliced) expression matrix
emat <- bm$spliced;
# intronic read (unspliced) expression matrix
nmat <- bm$unspliced
# filter expression matrices based on some minimum max-cluster averages
emat <- filter.genes.by.cluster.expression(emat,cell.colors,min.max.cluster.average = 0.2)
nmat <- filter.genes.by.cluster.expression(nmat,cell.colors,min.max.cluster.average = 0.05)
saveRDS(emat,file.path(outdir,'splice_ma.rds'))
saveRDS(nmat,file.path(outdir,'unsplice_ma.rds'))
# look at the resulting gene set
length(intersect(rownames(emat),rownames(nmat)))
intersect(rownames(emat),rownames(nmat))[1:5]
#gene γ 值计算
fit.quantile <- 0.02
n.cores<-n.cores
vel <- gene.relative.velocity.estimates(emat,nmat,deltaT=1,kCells = 5,fit.quantile = fit.quantile,n.cores=n.cores)#n.cores
saveRDS(vel,file.path(outdir,'oldfit.rds'))

#在降维空间画图
arrow.scale=3; cell.alpha=0.4; cell.cex=1;
pdf(file.path(outdir,'velocyto_projection.pdf'))
show.velocity.on.embedding.cor(embs,vel,n=200,scale='sqrt',cell.colors=ac(cell.colors,alpha=cell.alpha),
                               cex=cell.cex,arrow.scale=arrow.scale,show.grid.flow=TRUE,min.grid.cell.mass=0.5,grid.n=40,arrow.lwd=1,n.cores=n.cores)
dev.off()
#单个基因作图
purrr::walk(gene2show,purrr::safely(function(x){
        gene<-x
        pdf(file.path(outdir,paste0(x,'.pdf')),width=14,height = 5)
        gene.relative.velocity.estimates(emat,nmat,deltaT=1,kCells = 25,fit.quantile=fit.quantile,
                                         cell.emb=embs,cell.colors=cell.colors,show.gene=gene,old.fit=vel,do.par=T)
        dev.off()
}))

