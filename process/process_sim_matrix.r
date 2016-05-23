processSimTable <- function(CONDITION, CLUSTERMETHOD="complete", clean=TRUE) {

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
    mydata <- mydata[-(match("X418", rownames(mydata))), -(match("X418", colnames(mydata)))]
    mydata <- mydata[-(match("X413", rownames(mydata))), -(match("X413", colnames(mydata)))]
    mydata <- mydata[-(match("X11", rownames(mydata))), -(match("X11", colnames(mydata)))]
    mydata <- mydata[-(match("X13", rownames(mydata))), -(match("X13", colnames(mydata)))]

}
if (clean && (identical("block", CONDITION) || identical("master", CONDITION))) {
	
	mydata <- mydata[-(match("X706", rownames(mydata))), -(match("X706", colnames(mydata)))]
}

if (clean && (identical("text", CONDITION) || identical("master", CONDITION))) {
	
	mydata <- mydata[-(match("X828", rownames(mydata))), -(match("X828", colnames(mydata)))]
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
myhClust <- function(x) hclust(x, method=CLUSTERMETHOD)
pdf(paste(CONDITION, "_heatmap_symm_nodist.pdf", sep=""))
heatmap(matrix, symm=TRUE, distfun=distCor, hclustfun=myhClust)
dev.off()

pdf(paste(CONDITION, "_heatmap.pdf", sep=""))
heatmap(matrix)
dev.off()
setwd("/Users/connorbain/nudropbox/pencilcc_analysis/process/")

x <- hclust(distCor(matrix), method=CLUSTERMETHOD)
#plot(x)

pdf(paste(CONDITION, "_clustering_assessment.pdf", sep=""))
asw <- numeric(20)
## Note that "k=1" won't work!
for (k in 2:20)
  asw[k] <- pam(distCor(matrix), k) $ silinfo $ avg.width
k.best <- which.max(asw)
cat("silhouette-optimal number of clusters:", k.best, "\n")

plot(1:20, asw, type= "h", main = "pam() clustering assessment",
     xlab= "k  (# clusters)", ylab = "average silhouette width")
axis(1, k.best, paste("best",k.best,sep="\n"), col = "red", col.axis = "red")
dev.off()

clusplot(pam(distCor(matrix), k.best))

return(pam(distCor(matrix), k.best))
}