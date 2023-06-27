library(ggplot2)

# Input: infile (cell proportion table)
# Output: pie chart 

cell_prop = read.table(infile, header=T)


# Save the plot
ggsave(p, filename = sprintf('%s/%s_pieChart.png', outdir, bname))

