CONDITION <- "text"

mydata = read.csv(paste("/Users/connorbain/nudropbox/pencilcc_analysis/intra_results/", CONDITION, "_comp_table.csv"))

# Remove the first column labels
mydata <- mydata[-1]

# make the row names and column names the same
rownames(mydata) <- colnames(mydata)

# Remove 413 Outlier in Hybrid and Master
#mydata <- mydata[-(match("X413", rownames(mydata))), -(match("X413", colnames(mydata)))]


## Compute Euclidean Distance CMD
d <- dist(mydata)
fit <- cmdscale(d, eig=TRUE, k=2)
x <- fit$points[,1]
y <- fit$points[,2]
pdf(paste(CONDITION, "_mds_dist.pdf"))
plot(x,y,xlab="Coordinate 1", ylab="Coordinate 2", main=paste("Metric MDS for", CONDITION, " (dist"), type="n")
text(x, y, labels = rownames(mydata), cex=.7)
dev.off()

fit <- cmdscale(mydata, eig=TRUE, k=2)
x <- fit$points[,1]
y <- fit$points[,2]
pdf(paste(CONDITION, "_mds_raw.pdf"))
plot(x,y,xlab="Coordinate 1", ylab="Coordinate 2", main=paste("Metric MDS for", CONDITION, " (raw)"), type="n")
text(x, y, labels = rownames(mydata), cex=.7)
dev.off()

matrix <- data.matrix(mydata)
pdf(paste(CONDITION, "_heatmap_symm_dist.pdf"))
heatmap(matrix, symm=TRUE)
dev.off()

distCor <- function(x) as.dist(x)
pdf(paste(CONDITION, "_heatmap_symm_nodist.pdf"))
heatmap(matrix, symm=TRUE, distfun=distCor)
dev.off()

pdf(paste(CONDITION, "_heatmap.pdf")
heatmap(matrix)
dev.off()