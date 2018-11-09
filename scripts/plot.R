library(tidyverse)

df <- read.table(snakemake@input[['tsv']],sep='\t',header=F)

colnames(df) <- c('t','diff')

invisible(g <- ggplot(df,aes(t,diff)) + geom_line() +
    xlab("Time(s)") +
    ylab("Diff") +
    scale_y_continuous(limits=c(0,5)) +
    geom_hline(yintercept=1.0,linetype='dashed',color='red'))

ggsave(filename=snakemake@output[['pdf']],g)
