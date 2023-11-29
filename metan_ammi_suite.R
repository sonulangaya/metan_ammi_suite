###### Genotype × environment interaction and Stability analysis ##############

######################Stability analysis with metan ############################

library(metan)
library(ggplot2)
library(GGEBiplotGUI)
library(ggrepel)
library(readxl)
library(writexl)
library(openxlsx)
options(max.print = 10000)

#################data import####################################

stabdata<-read.csv(file.choose(),)
attach(stabdata)
str(stabdata)
options(max.print = 10000)

############################# factors with unique levels ####################

stabdata$ENV <- factor(stabdata$ENV, levels=unique(stabdata$ENV))
stabdata$GEN <- factor(stabdata$GEN, levels=unique(stabdata$GEN))
stabdata$REP <- factor(stabdata$REP, levels=unique(stabdata$REP))
str(stabdata)


############################ extract trait name from data file ######

traitall <- colnames(stabdata)[sapply(stabdata, is.numeric)]
traitall

########################### Data inspection and cleaning functions###############


inspect(stabdata, threshold= 50, plot=FALSE) %>% rmarkdown::paged_table()


for (trait in traitall) {
  find_outliers(stabdata, var = all_of(trait), plots = TRUE)
}

remove_rows_na(stabdata)
replace_zero(stabdata)
find_text_in_num(stabdata, var = all_of(trait))

######################### data analysis ##################################
###################### descriptive stats ################################


ds <- desc_stat(stabdata, stats="all", hist = TRUE, plot_theme = theme_metan())

write_xlsx(ds, "Descriptive.xlsx")

######################## mean performances ##############################
####################### mean of genotypes #############################

mg <- means_by(stabdata, GEN) 
mg
View(mg)

######################### mean of environments #######################

me <- means_by(stabdata, ENV)
me
View(me)

dm <- means_by(stabdata, GEN, ENV)

########### mean performance of genotypes across environments ###########

mge <- stabdata %>% 
  group_by(ENV, GEN) %>%
  desc_stat(stats="mean")
mge
View(mge)

######### Exporting all mean performances computed above #################

write_xlsx(list("Genmean" = mg, "Envmean" = me, "Genmeaninenv"= mge),"Mean peformances.xlsx")

#####################two-way table for all##########################


twgy_list <- list()

for (trait in traitall) {
    twgy_list[[trait]] <- make_mat(stabdata, GEN, ENV, val = trait)
}


result_twgy <- list()
for (trait in traitall) {
  twgy_result<- as.data.frame(twgy_list[[trait]])
  result_twgy[[trait]] <- twgy_result
}

twgy_wb <- createWorkbook()
for (trait in traitall) {
  addWorksheet(twgy_wb, sheetName = paste0(trait, ""))
  writeData(twgy_wb, sheet = trait, x = result_twgy[[trait]], startCol = 2, startRow = 1)
  writeData(twgy_wb, sheet = trait, x = rownames(twgy_list[[trait]]), startCol = 1, startRow = 2)
  writeData(twgy_wb, sheet = trait, x = c("GEN"), startCol = 1, startRow = 1)
}
  
saveWorkbook(twgy_wb, "TWmean.xlsx", overwrite = TRUE)

############### plotting performance across environments ################
############### make performance for all traits in one #################

perfor_list <- list()

for (trait in traitall) {
  perfor_list[[trait]] <- ge_plot(stabdata, ENV, GEN, !!sym(trait), values = FALSE, average = FALSE, plot_theme = theme_metan(), colour = TRUE)
  assign(paste0(trait, "_perfor"), perfor_list[[trait]])
}
######## print all plots once #########################################

for (trait in traitall) {
  print(perfor_list[[trait]])
}

##################### high quality save all in one  ############################

dir.create(file.path(getwd(), "perfor_plots"))

for (trait in traitall) {
  ggsave(filename = file.path("perfor_plots", paste0(trait, ".png")),
         plot = perfor_list[[trait]], width = 20, height = 40,
         dpi = 600, units = "cm")
}

###################### Genotype-environment winners ####################

win <- ge_winners(stabdata, ENV, GEN, resp = everything())
win
ranks <- ge_winners(stabdata, ENV, GEN, resp = everything(), type = "ranks")
ranks

write_xlsx(list("winner" = win, "ranks" = ranks),"Winner Rank.xlsx")

##################### ge or gge effects ##################
######################### combined for all ge effects #######################################
 

ge_list <- list()

for (trait in traitall) {
  ge <- ge_effects(stabdata, ENV, GEN, resp = trait, type = "ge")
  ge_list[[trait]] <- plot(ge)
}

################# print all plots once #########################################

for (trait in traitall) {
  print(ge_list[[trait]])
}

##################### high quality save all in one  ############################

dir.create(file.path(getwd(), "ge_plots"))

for (trait in traitall) {
  ggsave(filename = file.path("ge_plots", paste0(trait, ".png")),
         plot = ge_list[[trait]], width = 50, height = 15,
         dpi = 600, units = "cm")
}

########################## fixed effect models #############################
########################### Individual  and Joint anova ########################
############# Individual anova for all traits ##################################

aovind_list <- anova_ind(stabdata, env = ENV, gen = GEN, rep = REP, resp = everything())

result_aovind <- list()
for (trait in traitall) {
  ind_result<- as.data.frame(aovind_list[[trait]]$individual)
  result_aovind[[trait]] <- ind_result
}

aovind_wb <- createWorkbook()
for (trait in traitall) {
  addWorksheet(aovind_wb, sheetName = paste0(trait, ""))
  writeData(aovind_wb, sheet = trait, x = result_aovind[[trait]])
}
saveWorkbook(aovind_wb, "indaovall.xlsx", overwrite = TRUE)

################## Joint anova for all traits (ANOVA) ##################################

aovjoin_list <- anova_joint(stabdata, env = ENV, gen = GEN, rep = REP, resp = everything())

result_aovjoin <- list()
for (trait in traitall) {
  join_result<- as.data.frame(aovjoin_list[[trait]]$anova)
  result_aovjoin[[trait]] <- join_result
  }

aovjoin_wb <- createWorkbook()
for (trait in traitall) {
  addWorksheet(aovjoin_wb, sheetName = paste0(trait, ""))
  writeData(aovjoin_wb, sheet = trait, x = result_aovjoin[[trait]])
}
saveWorkbook(aovjoin_wb, "joinaovall.xlsx", overwrite = TRUE)

################## Joint anova for all traits (Details) (2) ########################

result_aovjoin2 <- list()
for (trait in traitall) {
  join_result2<- as.data.frame(aovjoin_list[[trait]]$details)
  result_aovjoin2[[trait]] <- join_result2
}

aovjoin_wb2 <- createWorkbook()
for (trait in traitall) {
  addWorksheet(aovjoin_wb2, sheetName = paste0(trait, ""))
  writeData(aovjoin_wb2, sheet = trait, x = result_aovjoin2[[trait]])
}
saveWorkbook(aovjoin_wb2, "joinaovall2.xlsx", overwrite = TRUE)

###################### AMMI based stability analysis for all (ANOVA)#####################################


ammi_list<-performs_ammi(stabdata, ENV, GEN, REP, resp = everything())

result_ammi <- list()
for (trait in traitall) {
  ammi_result<- as.data.frame(ammi_list[[trait]]$ANOVA)
  result_ammi[[trait]] <- ammi_result
}

ammi_wb <- createWorkbook()
for (trait in traitall) {
  addWorksheet(ammi_wb, sheetName = paste0(trait, ""))
  writeData(ammi_wb, sheet = trait, x = result_ammi[[trait]])
}
saveWorkbook(ammi_wb, "ammianova.xlsx", overwrite = TRUE)

###################### AMMI based stability analysis for all (model) #####################################

result_ammi2 <- list()
for (trait in traitall) {
  ammi_result2<- as.data.frame(ammi_list[[trait]]$model)
  result_ammi2[[trait]] <- ammi_result2
}

ammi_wb2 <- createWorkbook()
for (trait in traitall) {
  addWorksheet(ammi_wb2, sheetName = paste0(trait, ""))
  writeData(ammi_wb2, sheet = trait, x = result_ammi2[[trait]])
}
saveWorkbook(ammi_wb2, "ammimodel.xlsx", overwrite = TRUE)

###################### AMMI based stability analysis for all (Means G*E)#####################################

result_ammi3 <- list()
for (trait in traitall) {
  ammi_result3<- as.data.frame(ammi_list[[trait]]$MeansGxE)
  result_ammi3[[trait]] <- ammi_result3
}

ammi_wb3 <- createWorkbook()
for (trait in traitall) {
  addWorksheet(ammi_wb3, sheetName = paste0(trait, ""))
  writeData(ammi_wb3, sheet = trait, x = result_ammi3[[trait]])
}
saveWorkbook(ammi_wb3, "ammimeansge.xlsx", overwrite = TRUE)


######################### AMMI biplots for all in one AMMI 1#################### 

ammi1_list <- list()

for (trait in traitall) {
  ammi1_list[[trait]] <- plot_scores(ammi_list,
                                     var = trait,
                                     type = 1,
                                     first = "PC1",
                                     second = "PC2",
                                     x.lab = trait,
                                     repel = TRUE,
                                     max_overlaps = 50,
                                     shape.gen = 21,
                                     shape.env = 23,
                                     size.shape.gen = 2,
                                     size.shape.env = 3,
                                     col.bor.gen = "#215C29",
                                     col.bor.env = "#F68A31",
                                     col.line = "grey",
                                     col.gen = "#215C29",
                                     col.env = "#F68A31",
                                     size.tex.gen = 3,
                                     size.tex.env = 3,
                                     size.tex.lab = 12,
                                     size.line = .4,
                                     size.segm.line = .4,
                                     leg.lab = c("Environment", "Genotype"),
                                     line.type = 'dashed') + theme (panel.background = element_rect(fill = "white"))
                                    assign(paste0(trait, "_ammi1"), ammi1_list[[trait]])
}
######## print all plots once #########################################

for (trait in traitall) {
  print(ammi1_list[[trait]])
}

##################### high quality save all in one  ############################

dir.create(file.path(getwd(), "ammi1_plots"))

for (trait in traitall) {
  ggsave(filename = file.path("ammi1_plots", paste0(trait, ".png")),
         plot = ammi1_list[[trait]], width = 15, height = 15,
         dpi = 600, units = "cm")
}

######################## AMMI biplots for all in one AMMI 2#################### 

ammi2_list <- list()

for (trait in traitall) {
  ammi2_list[[trait]] <- plot_scores(ammi_list,
                                     var = trait,
                                     type = 2,
                                     first = "PC1",
                                     second = "PC2",
                                     repel = TRUE,
                                     max_overlaps = 50,
                                     shape.gen = 21,
                                     shape.env = 23,
                                     size.shape.gen = 2,
                                     size.shape.env = 3,
                                     col.bor.gen = "#215C29",
                                     col.bor.env = "#F68A31",
                                     col.line = "grey",
                                     col.gen = "#215C29",
                                     col.env = "#F68A31",
                                     size.tex.gen = 3,
                                     size.tex.env = 3,
                                     size.tex.lab = 12,
                                     size.line = .4,
                                     size.segm.line = .4,
                                     leg.lab = c("Environment", "Genotype"),
                                     line.type = 'dashed') + theme (panel.background = element_rect(fill = "white"))
  assign(paste0(trait, "_ammi2"), ammi2_list[[trait]])
}
######## print all plots once #########################################

for (trait in traitall) {
  print(ammi2_list[[trait]])
}

##################### high quality save all in one  ############################

dir.create(file.path(getwd(), "ammi2_plots"))

for (trait in traitall) {
  ggsave(filename = file.path("ammi2_plots", paste0(trait, ".png")),
         plot = ammi2_list[[trait]], width = 15, height = 15,
         dpi = 600, units = "cm")
}

