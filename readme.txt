软件简介
单细胞 RNA 测序可以以高定量准确度、灵敏度和通量来揭示 RNA 丰度。然而，这种方法仅捕获某个时间点的静态快照，无法在时间上重现（如胚胎发生或组织再生）发育过程的RNA表达平衡变化。Velocyto 可以通过在常见的单细胞 RNA 测序方案中区分未剪接和剪接的 mRNA 来直接估计 RNA 表达平衡变化。 

简要使用方法
先运行 run.sh 获得单样本 velocyto.rds，再运行 plot.sh 画图。
由于 RNA velocity 分析的前提是从单细胞 RNA-seq 数据中区分未成熟 mRNA (unspliced) 和成熟 mRNA(spliced)，所以需要从与基因组进行比对后得到 bam 文件中提取 spliced，unspliced 和 ambiguous 信息。得到 .loom 为后缀的文件。由于原始 loom 文件会修改 cell barcode，velocyto.prep.R 会额外将其还原后处理成 seurat 对象并保存为 velocyto.rds 以便下游分析。多样本可直接 merge 合并后统一分析。
除 velocyto.rds 外，velocyto.plot.R 还需提供用于提供聚类和降维信息的 seurat 对象，即可在该对象的降维空间投射 velocyto 预测结果（即箭头）。注意 seurat 对象的 cell barcodes 命名须
和 velocyto.rds 保持一致。

参数说明
velocyto.prep.R:
 --bam	STAR 比对后的 bam 格式文件。可在标准流程结果路径，eg：alignmentYaml/SAMPLE/STAR/SAMPLE_SortedByCoordinate.bam（seekone）；cellrangerYaml/SAMPLE/outs/possition_sorted.bam(10x)找到。
 --filtered_barcode	初步过滤后的 barcodes 文件。可在在标准流程结果路径下，eg：countBarcodeYaml/SAMPLE/filtered_feature_bc_matrix/barcodes.tsv.gz（seekone）；cellrangerYaml/SAMPLE/outs/filtered_feature_bc_matrix/barcodes.tsv.gz(10x)找到。
 --species	目前支持 human|mouse|rat，可在./ref文件夹中自定义 gtf 文件，命名为 SPECIES_genes.gtf。
 --add_tag	T|F，目前的 seekone 标准流程比对结果 bam 文件没有 CB\UB tag，选择 T 时会加上，10x 则不需要，使用没有相关 tag 的 bam 文件会报错。
 --outdir	默认是 ./output
 --sample	sample ID，需要唯一

velocyto.plot.R:
 --velocyto_rds	包含 4 个 assay 的 seurat 对象（velocyto.rds）。可在 velocyto.prep.R 的结果文件中找到。
 --seurat_obj2project	用于画图的 seurat 对象，rds格式。eg：basicSeuratYaml/SAMPLE/SAMPLE_seurat.rds。
 --outdir	输出文件路径，默认是./output。
 --reduction_space	seurat_obj 的降维空间名称，默认是 umap。
 --default_assay	seurat_obj 的 default_assay 名称，默认是 RNA。
 --gene2show	需要画图的基因列表，多个基因可以,分隔，没有 fit 出 γ 值的基因不会出出图。
 --old_fit	oldfit.rds。不再处理原始 velocyto.rds ，使用已有拟合结果，可用于降低画图时间。
 --n.cores	需求核数，默认是 1。


结果文件说明
run.sh：
./output/SAMPLE/
 -cellsorted_SAMPLE.addtag.bam(velocyto 软件运行中间结果)
 -demo_U47GT.loom(velocyto 软件原始结果 loom 文件)
 -demo.addtag.bam(add_tag 参数为 T 时，会产生一个加了 CB/UB tag 的 bam 文件)
 -demo.addtag.bam.bai(bam index)
 -velocyto.rds(最终处理后，可直接下游画图的结果文件)
 
plot.sh：
./output/ 
 -velocyto_projection.pdf(添加 velocyto 预测向量的降维结果图)
 -oldfit.rds(拟合 γ 值后的 velocyto 对象，可用于减少画图时间)
 -splice_ma.rds(velocyto 对象筛选后的 splice assay matrix)
 -unsplice_ma.rds(velocyto 对象筛选后的 unsplice assay matrix)
 -GENE.pdf(单个基因的拟合结果)

 
