library(ggplot2)
library(RColorBrewer)

# read table
cell_table = read.table(infile, header = T, row.names = 1)

# Preprossessing the data frame
df = data.frame(sampleid = rep(colnames(cell_table), each = nrow(cell_table)), 
                celltype = rep(rownames(cell_table), times = ncol(cell_table)),
                percentage = unlist(cell_table) * 100)
rownames(df) = NULL

# Change columns and rows into factors to lock down the order
df$sampleid = factor(df$sampleid, levels = c('JOHR1_D135','SONR1_D135','NHDF2_D130','JOHR_D262','SONR_D262','NHDF2_D320'))
#df$celltype = factor(df$celltype, levels = c('Cone','Rod','RPE','AC','BC','HC','RGC','Astro','MG','RPC'))
df$celltype = factor(df$celltype, levels = c('Cone','Rod','AC','BC','HC','RGC','MG','PRPC','NRPC'))

# Make gg bar plot with customized themes, colors, and labels
p <- ggplot(df, aes(fill = celltype, y = percentage, x = sampleid)) + 
  geom_bar(position='stack', stat='identity', width = 0.7) + 
# scale_fill_manual(values = c("#E41A1C", "#377EB8", "#4DAF4A", "#984EA3","#FF7F00", "#FFFF33", "#8DD3C7", "#F781BF", "#FCCDE5", "#A9A9A9")) + 
  scale_fill_manual(values = c("#E41A1C", "#377EB8", "#4DAF4A", "#984EA3","#FF7F00", "#FFFF33", "#8DD3C7", "#F781BF", "#FCCDE5")) + 
	labs(x='Sample ID', y='Percentage %', title='Cell Type Proportion by Samples') +
  theme(plot.title = element_text(hjust=0.5, size=15, face='bold')) + 
# theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1)) +
	theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), 
        panel.background = element_blank(), axis.line = element_line(colour = "black"))

# Save plot
ggsave(p, filename = sprintf('%s/%s_stackedBar.png', outdir, bname))
