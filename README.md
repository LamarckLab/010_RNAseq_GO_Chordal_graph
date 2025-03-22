# 010_RNAseq_GO_Chordal_graph
转录组下游 —— 用弦图可视化GO富集结果

首先需要准备两个csv -- 分别存储Description与geneID的对应关系以及gene与log2FoldChange的关系

两个文件为：Description_geneID.csv与gene_Fold.csv

merge.R用来将这两个csv合并成merge.csv，供弦图绘制
