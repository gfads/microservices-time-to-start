#!/usr/bin/env Rscript

pdf(NULL) # Avoid creating Rplots.pdf

library(ggplot2)

#
#  It would be so great to reuse this function (it is basically a copy & paste
#  from the script for plotting the binsizes chart).
#
plot_func <- function(ylab, data, filename) {
  microservice=c(
                 rep("carts",    2),
                 rep("orders",   2),
                 rep("payment",  2),
                 rep("shipping", 2),
                 rep("user",     2)
                 )
  languages=c(rep("Java",2),
              rep("Java",2),
              rep("Go Lang",2),
              rep("Java",2),
              rep("Go Lang",2))
  condition=rep(c("Instrumented\nMicroservices", "Rbinder") , 5)
  plotdata=data.frame(microservice,languages,condition,data)

  # Bar plot with error bars.
  theme_set(theme_bw())
  plot <- ggplot(plotdata, aes(x=microservice, y=data, fill=condition)) +
                  geom_bar(stat="identity", position="dodge", colour="black")
  plot + labs(x="Microservice", y=ylab) +
    scale_fill_manual("Scenario",
                      values = c("Instrumented Microservices"="white",
                                 "Rbinder"="gray")
                      ) +
    facet_grid(~languages, scales='free', space='free') +
    theme(legend.position="top",
          text = element_text(size=18))
  ggsave(filename=paste('./', filename, '.pdf', sep=''), height=5)
}

means <- c()
errs <- c()
sds <- c()
meansidx <- 1

for(service in c('carts', 'orders', 'payment', 'shipping', 'user')) {
  for(scenario in c('instrumented', 'rbinder')) {
    filename <- paste('./logs/', scenario, '-', service, '-start-time', '.log', sep='')
    replicaset <- read.csv(file=filename, head=FALSE)
    means[meansidx] <- mean(replicaset$V1)
    sds[meansidx] <- sd(replicaset$V1)
    errs[meansidx] <- qt(0.975, df=length(replicaset$V1)-1)*sd(replicaset$V1)/sqrt(length(replicaset$V1))
    meansidx <- meansidx + 1
  }
}

#flicts = data.frame(means, sds)
#print(flicts)

plot_func("Time (s)", means, 'time')
