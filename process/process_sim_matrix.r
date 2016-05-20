processSimTable <- function(CONDITION, clean=TRUE) {

setwd("/Users/connorbain/nudropbox/pencilcc_analysis/process/graph_output")

file_path <- "/Users/connorbain/nudropbox/pencilcc_analysis/intra_results/"

if (identical("master", CONDITION)) {
	file_path <- "/Users/connorbain/nudropbox/pencilcc_analysis/inter_results/"
}

mydata = read.csv(paste(file_path, CONDITION, "_comp_table.csv" , sep=""))

# Remove the first column labels
mydata <- mydata[-1]


# make the row names and column names the same
rownames(mydata) <- colnames(mydata)

if (clean && (identical("master", CONDITION) || identical("hybrid", CONDITION))) {
    # Remove 413 Outlier in Hybrid and Master
    mydata <- mydata[-(match("X413", rownames(mydata))), -(match("X413", colnames(mydata)))]
}

## Compute Euclidean Distance CMD
d <- dist(mydata)
fit <- cmdscale(d, eig=TRUE, k=2)
x <- fit$points[,1]
y <- fit$points[,2]
pdf(paste(CONDITION, "_mds_dist.pdf", sep=""))
plot(x,y,xlab="Coordinate 1", ylab="Coordinate 2", main=paste("Metric MDS for", CONDITION, " (dist"), type="n")
text(x, y, labels = rownames(mydata), cex=.7)
dev.off()

fit <- cmdscale(mydata, eig=TRUE, k=2)
x <- fit$points[,1]
y <- fit$points[,2]
pdf(paste(CONDITION, "_mds_raw.pdf", sep=""))
plot(x,y,xlab="Coordinate 1", ylab="Coordinate 2", main=paste("Metric MDS for", CONDITION, " (raw)"), type="n")
text(x, y, labels = rownames(mydata), cex=.7)
dev.off()

matrix <- data.matrix(mydata)
pdf(paste(CONDITION, "_heatmap_symm_dist.pdf", sep=""))
heatmap(matrix, symm=TRUE)
dev.off()

distCor <- function(x) as.dist(x)
pdf(paste(CONDITION, "_heatmap_symm_nodist.pdf", sep=""))
heatmap(matrix, symm=TRUE, distfun=distCor)
dev.off()

pdf(paste(CONDITION, "_heatmap.pdf", sep=""))
heatmap(matrix)
dev.off()
setwd("/Users/connorbain/nudropbox/pencilcc_analysis/process/")
}