# 读入第一个CSV：包含"Description"和"GeneID"两列
df1 <- read.csv("C:/Users/Lamarck/Desktop/Description_geneID.csv",
                stringsAsFactors = FALSE)

# 读入第二个CSV：包含"gene"和"log2FoldChange"两列
df2 <- read.csv("C:/Users/Lamarck/Desktop/gene_Fold.csv",
                stringsAsFactors = FALSE)

# 创建一个空的数据框，列名与目标一致
result <- data.frame(gene = character(),
                     Description = character(),
                     log2FoldChange = numeric(),
                     stringsAsFactors = FALSE)


# 逐行遍历df1
for(i in seq_len(nrow(df1))) {
  desc <- df1$Description[i]        # 当前行的描述
  gene_string <- df1$geneID[i]      # 当前行中基因字符串，可能包含/分隔
  gene_list <- strsplit(gene_string, "/")[[1]]  # 按"/"分割成向量
  
  # 再逐个基因处理
  for(g in gene_list) {
    # 到df2中寻找与该基因匹配的行
    match_idx <- which(df2$gene == g)
    if(length(match_idx) == 0) {
      # 如果在df2中找不到该基因，则用NA
      l2fc <- NA
    } else {
      # 如果找到多个，这里演示只取第一个匹配值
      l2fc <- df2$log2FoldChange[ match_idx[1] ]
    }
    
    # 将当前基因及其对应信息追加到result
    result <- rbind(result,
                    data.frame(gene = g,
                               Description = desc,
                               log2FoldChange = l2fc,
                               stringsAsFactors = FALSE))
  }
}

# 将结果写出到CSV
write.csv(result, "C:/Users/Lamarck/Desktop/merge.csv", row.names = FALSE)
