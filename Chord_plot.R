library(circlize)  # 核心包，用来画弦图（Chord Diagram）
library(cols4all)  # 用来生成丰富调色板（比如 Set3, rainbow 等）

# Step1: 读取数据
merge_data1 <- read.csv("C:/Users/Lamarck/Desktop/Chordal_graph.csv",
                        header = TRUE,
                        check.names = FALSE,
                        fileEncoding = "UTF-8-BOM")

# 查看前几行，确认列名及内容
head(merge_data1)

# Step 2: 将数据整理为矩阵 set1

# 提取去重后的基因/通路
all_genes    <- unique(merge_data1$gene)
all_pathway  <- unique(merge_data1$Description)

# 构建空矩阵，并填充 log2FoldChange
sets <- data.frame(
  matrix(0,
         nrow = length(all_genes),
         ncol = length(all_pathway),
         dimnames = list(all_genes, all_pathway))
)

for (g in all_genes) {
  for (p in all_pathway) {
    row_match <- merge_data1[merge_data1$gene == g & merge_data1$Description == p, ]
    if (nrow(row_match) > 0) {
      # 若存在多个匹配行，这里只取第一个 log2FoldChange
      sets[g, p] <- row_match$log2FoldChange[1]  
    }
  }
}


# 将数据框转换为矩阵
set1 <- as.matrix(sets)

# Step 3: 设定调色板、绘图参数

# 先统计基因和通路的数量
unique_count1 <- length(unique(merge_data1$Description))  # 通路数
unique_count2 <- length(unique(merge_data1$gene))         # 基因数

# grid.col: 给行名(基因)和列名(通路)分别设颜色
grid.col <- NULL 
grid.col[colnames(sets)] <- c4a("brewer.set3",    unique_count1)    # 通路配色
grid.col[rownames(sets)] <- c4a("rainbow_wh_rd", unique_count2)     # 基因配色

# grid.col2: 控制文本颜色（让通路名透明，基因名黑色）
grid.col2 <- NULL
grid.col2[colnames(sets)] <- "transparent"
grid.col2[rownames(sets)] <- "black"

# Step 4: 正式绘图

pdf("C:/Users/Lamarck/Desktop/Chordal_GO_DOWN.pdf", width = 8, height = 4)

# 调整边距 (下、左、上、右)
par(mar = c(4, 1, 1, 16))

# 绘制弦图
chordDiagram(
  set1,
  diffHeight = 0.06,
  annotationTrack = c("grid"),
  annotationTrackHeight = c(0.1, 10),
  grid.col = grid.col,
  link.lwd = 0.02,
  transparency = 0.5
)

# 给扇区添加文本注释
for(si in get.all.sector.index()) {
  myCol <- grid.col2[si]
  xlim  <- get.cell.meta.data("xlim", sector.index = si, track.index = 1)
  ylim  <- get.cell.meta.data("ylim", sector.index = si, track.index = 1)
  
  circos.text(
    mean(xlim), ylim[2],
    labels = si,
    sector.index = si, 
    track.index  = 1, 
    facing       = "clockwise", 
    col          = myCol,
    cex          = 0.8,
    adj          = c(0, 0.5),
    niceFacing   = TRUE,
    xpd          = TRUE  # 允许文本超出图形范围
  )
}

# 设置图例
legend(
  x     = 1.8, 
  y     = 0.6,            
  pch   = 22,                          
  title = "Pathway",    
  title.adj= 0,                      # 标题左对齐 
  bty   = "n",                       
  legend= colnames(set1),            # 图例标签（通路名）
  col   = grid.col[colnames(set1)],  # 方形边框颜色
  pt.bg = grid.col[colnames(set1)],  # 方形填充颜色
  cex   = 0.8,                       # 图例文本大小
  pt.cex= 2.5,                       # 图例中点大小
  border= "black",
  ncol  = 1,
  xpd   = TRUE
)

dev.off()
