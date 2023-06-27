library(ggplot2)

# Input: infile, celltype, bname, outdir

#Read data files
obj = read.csv(infile, header = T)
#obj = read.table(infile, header = T, sep ="\t")

# Convert to data frame
dframe = as.data.frame(obj)

# Subset only biological process
#dframe = subset(dframe, dframe$ONTOLOGY == "BP")
dframe = subset(dframe, dframe$source == "GO:BP")

# Calculate -log10 of p.adjust
#dframe$p.adjust.log = -log10(dframe$p.adjust)
# Sort the dataframe in descending order of p.adjust.log
#dframe <-dframe[order(dframe$p.adjust.log, decreasing = TRUE),]
dframe <-dframe[order(dframe$negative_log10_of_adjusted_p_value, decreasing = TRUE),]

# Take the top 20 rows of the data frame
dframe = dframe[1:20,]

# Prepare for title
name = strsplit(celltype, "_")

# Plot bar plot
p = ggplot(data = dframe, aes(x=reorder(term_name,negative_log10_of_adjusted_p_value),y=negative_log10_of_adjusted_p_value)) +
geom_bar(stat="identity", fill="dark blue") +
labs(y = "-log10(adj.pvalue)") +
ggtitle(paste(name[[1]][1],name[[1]][2],"Enriched Biological Process")) +
theme(axis.text.y=element_text(size=10), 
	axis.text.x=element_text(size=10),
	axis.title.y=element_blank(),
	axis.title.x=element_text(size=10),
	axis.ticks=element_blank(),
	plot.title=element_text(size=16),
	panel.grid.major = element_blank(), 
	panel.grid.minor = element_blank(),
	panel.background = element_blank()) +
coord_flip()

#Save graph
ggsave(p, filename = sprintf('%s/%s.png', outdir, bname), height=height, width=width)
