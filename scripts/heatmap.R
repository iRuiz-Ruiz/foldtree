# Load necessary libraries
library(ggplot2)
library(reshape2)
library(pheatmap)
library(dplyr)
library(heatmap3)
#BiocManager::install("ComplexHeatmap") 
library(ComplexHeatmap)

setwd("C:/Users/ek23810/OneDrive - University of Bristol/term2_project/foldtree_tidy/outputs/mining/redo8-full/heatmap")

#<---------------- select the dataset
#the full dataset
#data <- read.csv("C:/Users/ek23810/OneDrive - University of Bristol/term2_project/foldtree_tidy/outputs/mining/redo8-full/tree_metadata/complfulltree_map_all.txt")

#the subset dataset
#data <- read.csv("C:/Users/ek23810/OneDrive - University of Bristol/term2_project/foldtree_tidy/outputs/mining/redo8-full/tree_metadata/filtered_phobius_cdhit_RL.txt")
#the expassy2 - dataset
#data <- read.csv("C:/Users/ek23810/OneDrive - University of Bristol/term2_project/foldtree_tidy/outputs/mining/redo8-full/tree_metadata/subset_expassy2.txt")
#the expassy3 - dataset
data <- read.csv("C:/Users/ek23810/OneDrive - University of Bristol/term2_project/foldtree_tidy/outputs/mining/redo8-full/tree_metadata/subset_expassy3.txt")

#taxa label
taxa_order <- read.csv("C:/Users/ek23810/OneDrive - University of Bristol/term2_project/foldtree_tidy/tax_sum_label.csv")
#taxa_order <- read.csv("C:/Users/ek23810/OneDrive - University of Bristol/term2_project/foldtree_tidy/tax_sum_label_tree.csv")

#pfam label
#<----------- select order 
#Before tree
#gpcr_order <- read.csv("C:/Users/ek23810/OneDrive - University of Bristol/term2_project/foldtree_tidy/pfam_labels_heatmap.csv")

#After tree
gpcr_order_after <- read.csv("C:/Users/ek23810/OneDrive - University of Bristol/term2_project/foldtree_tidy/pfam_labels_heatmap_after_tree.csv")
gpcr_order <- gpcr_order_after
  
names(data)[names(data) == 'Org'] <- 'Org_Old'
names(data)[names(data) == 'Org_Uq'] <- 'Org'

data_merged <- merge(x = data, y = taxa_order, by = "Org", all = TRUE)
data_merged <- merge(x = data_merged, y = gpcr_order, by = "gpcr", all.x = TRUE)

# Define the gpcr values you want to subset
main_gpcr_values <- c("PF00001", "PF00002", "PF00003", "PF01534", "PF02101", 
                 "PF05462", "PF02076", "PF02101", "PF02116", "PF02076", 
                 "PF06814", "PF10192", "PF11710", "PF12430")

# Define the gpcr values you want to subset
crest_gpcr_values <- c("PF13965", "PF15100", "PF05875", "PF05875", "PF03006","PF04080")

# Define the gpcr values you want to subset
other_gpcr_values <- c("PF02117", "PF02118", "PF02175", "PF03125", "PF03383", 
                       "PF03402", "PF03619", "PF05296", "PF06454", 
                       "PF10292", "PF10316", "PF10317", "PF10318", "PF10319", 
                       "PF10320", "PF10321", "PF10322", "PF10323", "PF10324", 
                       "PF10325", "PF10326", "PF10327", "PF10328", "PF11970", 
                       "PF13853")

the_tree <- c("PF00001", "PF03402", "PF05296", "PF00002", "PF01534", "PF02101", 
               "PF05462", "PF00003", "PF02076", "PF12430", "PF06814", "PF06454", 
               "PF10192", "PF02116","PF03619","PF11710","PF11970","PF13853")

#merge with taxonomy order
data_merged$New_Label <- paste(data_merged$Label, data_merged$Scientific_Name, sep="_")
data_merged$Name <- gsub("119_Git3-2", "118_Git3", data_merged$Name)

# Subset the dataframe based on these gpcr values
df_subset_main <- subset(data_merged, gpcr %in% main_gpcr_values)
df_subset_crest <- subset(data_merged, gpcr %in% crest_gpcr_values)
df_subset_other <- subset(data_merged, gpcr %in% other_gpcr_values)

df_subset_tree <- subset(data_merged, gpcr %in% the_tree)

# Create a contingency table that counts the number of gpcr per org
                        # organism                  gpcr_name
gpcr_count <- table(df_subset_tree$New_Label, df_subset_tree$Name)
gpcr_count_truncated <- pmin(gpcr_count, 100)

# Define the breaks for your custom color palette
#breaks <- c(0, 1, 2, 3, 5, 10, 20, 30, 50, 100)

# Define the custom colors corresponding to these breaks
#custom_colors <- c("black", "#44471C", "#949b38", "#dee33e", "#e9d030", "#ebbb29", "#f47c24", "#f15925", "#ee2629", "#ac3a6a")

# Create the color function
#col_fun <- colorRamp2(breaks, custom_colors)

#### <--------------------------- missing labels: only for filtered ------------------------------------------------------------------
# Include the missing labels - only for filtered
#labels <- c("422_CHOCR_Chondrus crispus", "644_9EUKA8_Haptolina ericina", 
#            "421_9FLOR_Gracilariopsis chorda",
#            "412_NEOHI_Neoporphyra haitanensis","361_9EUKA22_Stereomyxa ramosa",
#            "652_9EUKA5_Coccolithus_baarudii")

# Include the missing labels - only for subset

labels <- c("722_CHOCR_Chondrus crispus", "534_9EUKA8_Haptolina ericina", 
            "721_9FLOR_Gracilariopsis chorda",
            "735_NEOHI_Neoporphyra haitanensis","354_9EUKA22_Stereomyxa ramosa",
            "511_9EUKA5_Coccolithus_baarudii") #"451_MICPC_Micromonas pusilla",
            #"212_ALLMA_Allomyces macrogynus")
            #"416_9RHOD2_Erythrolobus australicus")

# Create a matrix of 0s with the same number of columns as 'mat' and rows equal to the length of 'labels'
zeros_matrix <- matrix(0, nrow = length(labels), ncol = ncol(gpcr_count_truncated))
# Set the row names for the new labels
rownames(zeros_matrix) <- labels
# Combine the original matrix with the zeros matrix
gpcr_count_truncated <- rbind(gpcr_count_truncated, zeros_matrix)

# Reorder rows alphabetically
gpcr_count_truncated <- gpcr_count_truncated[order(rownames(gpcr_count_truncated)), , drop = FALSE]

# <--------------------------- get the heatmap
# Here we assume the maximum count is 200; adjust if necessary
breaks <- c(-1, 0, 1, 2, 3, 5, 10, 20, 30, 50, 100) 

# Define the custom colors corresponding to these breaks
custom_colors <- colorRampPalette(c("black", "darkolivegreen","yellow","orange","red", "#6d215c"))(length(breaks) - 1)

png("new_new/RL_heatmap_taxa_new_full.png", width = 4000, height = 3000)

# Create a heatmap using heatmap3
# heatmap3 only accept matrix as input data
heatmap3(gpcr_count_truncated, scale = "none", Rowv = NA, Colv = NA, 
         main = "Heatmap of GPCR counts per Organism", xlab = "Name", ylab = "Label", 
         col = custom_colors, breaks = breaks)

# Close the device to save the file
dev.off()


#Stop
#extract taxa information
# Extract the two columns into a new dataframe
#taxa_sn <- data_merged[, c("Org", "Label", "New_Label")]
# Assuming your dataframe is called 'df' and the column to check for duplicates is 'Column1'
#taxa_sn_uq <- taxa_sn %>% distinct(New_Label, .keep_all = TRUE)

