library(ggplot2)
library(ggvenn)
library(ggVennDiagram)

# Note: Input data type need to be changed into the following for any venn diagram function to work
# genes <- paste("gene",1:1000,sep="")
# x <- list(
#   A = sample(genes,300), 
#   B = sample(genes,525), 
#   C = sample(genes,440),
#   D = sample(genes,350)
# )

cone = read.table("Desktop/Lab/ABCA4 Project/Monocle3/DEGs/Cone_DEG.txt", fill = T)
cone = cone[[1]]

rod = read.table("Desktop/Lab/ABCA4 Project/Monocle3/DEGs/Rod_DEG.txt", fill = T)
rod = rod[[1]]

ac = read.table("Desktop/Lab/ABCA4 Project/Monocle3/DEGs/AC_DEG.txt", fill = T)
ac = ac[[1]]

rpe = read.table("Desktop/Lab/ABCA4 Project/Monocle3/DEGs/RPE_DEG.txt", fill = T)
rpe = rpe[[1]]

x = list(Cone = cone, Rod = rod, AC = ac, RPE = rpe)

# Use ggvenn() function, old school venn diagram, self-defined color palette
# p = ggvenn(x, fill_color = c("#0073C2FF", "#EFC000FF", "#868686FF", "#CD534CFF"),
#       stroke_size = 0.5, set_name_size = 4)

# Use ggVennDiagram() function, prettier color palette
p = ggVennDiagram(x, label_alpha = 0, label_color = "white", edge_lty = "blank") +
  scale_color_brewer(palette = "Paired")

# Save plot
ggsave(p, filename = "Desktop/Lab/ABCA4 Project/Monocle3/DEGs/DEG_venn.png")

