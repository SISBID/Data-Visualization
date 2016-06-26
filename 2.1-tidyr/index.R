## ---- echo = FALSE-------------------------------------------------------
knitr::opts_chunk$set(
  message = FALSE,
  warning = FALSE,
  collapse = TRUE,
  comment = "#>",
  fig.height = 4,
  fig.width = 8,
  fig.align = "center",
  cache = FALSE
)

## ----echo=FALSE----------------------------------------------------------
library(ggplot2)
library(tidyr)
library(dplyr)
library(lubridate)
library(scales)
library(readr)
rates <- read_csv("http://dicook.github.io/Monash-R/data/rates.csv")
rates.sub <- select(rates, date, AUD, NZD)
rates.sub.m <- gather(rates.sub, currency, rate, -date)
rates.sub.m$date <- as.POSIXct(rates.sub.m$date)
qplot(date, rate, data=rates.sub.m, geom="line", colour=currency) + 
  scale_x_datetime(breaks = date_breaks("1 month"), labels = date_format("%b")) + 
  scale_color_brewer(palette="Dark2") + theme_bw()

## ------------------------------------------------------------------------
library(readr)
rates <- read_csv("http://dicook.github.io/Monash-R/data/rates.csv")
rates[1:5,1:8]

## ------------------------------------------------------------------------
qplot(date, AUD, data=rates)

## ------------------------------------------------------------------------
qplot(date, AUD, data=rates, geom="line")

## ------------------------------------------------------------------------
qplot(date, AUD, data=rates, geom=c("line", "point"))

## ------------------------------------------------------------------------
ggplot(data=rates, aes(x=date, y=AUD)) + geom_point() + geom_line()

## ------------------------------------------------------------------------
ggplot(data=rates, aes(x=date, y=AUD)) + geom_line() +
  geom_line(aes(y=NZD), colour="blue") + 
  geom_line(aes(y=GBP), colour="red")

## ------------------------------------------------------------------------
rates.sub <- select(rates, date, AUD, NZD, GBP)
rates.sub.m <- gather(rates.sub, currency, rate, -date)
qplot(date, rate, data=rates.sub.m, geom="line", colour=currency)

## ------------------------------------------------------------------------
rates.sub <- mutate(rates.sub, AUD=scale(AUD), NZD=scale(NZD), GBP=scale(GBP))
rates.sub$date <- as.Date(rates.sub$date)
rates.sub.m <- gather(rates.sub, currency, rate, -date)
qplot(date, rate, data=rates.sub.m, geom="line", colour=currency)

## ------------------------------------------------------------------------
qplot(AUD, NZD, data=rates.sub) + theme(aspect.ratio=1)

## ------------------------------------------------------------------------
qplot(AUD, NZD, data=rates.sub, geom="line") + theme(aspect.ratio=1)

## ------------------------------------------------------------------------
qplot(AUD, NZD, data=rates.sub, geom=c("density2d", "point")) + theme(aspect.ratio=1)

## ---- fig.show='hold', fig.align='default', fig.width=3, fig.height=3----
AUD <- rates[,c("date", "AUD")]
AUD.1 <- lag(AUD$AUD, 1)
AUD.2 <- lag(AUD$AUD, 2)
AUD.7 <- lag(AUD$AUD, 7)
qplot(AUD, AUD.1, data=rates.sub) + theme(aspect.ratio=1)
qplot(AUD, AUD.2, data=rates.sub) + theme(aspect.ratio=1)
qplot(AUD, AUD.7, data=rates.sub) + theme(aspect.ratio=1)

## ----echo=FALSE, fig.show='hide'-----------------------------------------
qplot(AUD, NZD, data=rates.sub) + geom_rug() + theme(aspect.ratio=1)

## ------------------------------------------------------------------------
qplot(AUD, data=rates.sub, geom="histogram") 

## ------------------------------------------------------------------------
qplot(AUD, data=rates.sub, geom="density", fill=I("black")) 

## ------------------------------------------------------------------------
qplot(date, rate, data=rates.sub.m, geom="line", colour=currency) +
  xlab("Date") + ylab("Standardized rates") + 
  ggtitle("Cross rates 23/2/2015-11/11/2015")

## ------------------------------------------------------------------------
qplot(date, rate, data=rates.sub.m, geom="line", colour=currency) +
  xlab(expression(Date[i]^2~ mu ~ pi * sigma)) + ylab("Standardized rates") + 
  ggtitle("Cross rates 23/2/2015-11/11/2015")

## ------------------------------------------------------------------------
rates.sub.m$date <- as.POSIXct(rates.sub.m$date)
p <- qplot(date, rate, data = rates.sub.m, geom = "line", colour = currency) +
  scale_x_datetime(breaks = date_breaks("1 month"), labels = date_format("%b")) +
  scale_y_continuous("Standardized rates") 
p

## ------------------------------------------------------------------------
p + theme(legend.position = "bottom")

## ------------------------------------------------------------------------
p + scale_color_brewer("", palette = "Dark2")

## ------------------------------------------------------------------------
library(ggthemes)
p + theme_stata()

## ------------------------------------------------------------------------
p + theme_tufte()

## ------------------------------------------------------------------------
p + theme_economist()

## ---- fig.width=4.5, fig.show='hold', fig.align='default'----------------
library(dichromat)
clrs <- hue_pal()(3)
p + scale_color_manual("", values=clrs) + theme(legend.position = "none")
clrs <- dichromat(hue_pal()(3))
p + scale_color_manual("", values=clrs) + theme(legend.position = "none")

## ---- fig.width=4.5, fig.show='hold', fig.align='default'----------------
library(RColorBrewer)
clrs <- brewer.pal(3, "Dark2")
p + scale_color_manual("", values=clrs) + theme(legend.position = "none")
clrs <- dichromat(brewer.pal(3, "Dark2"))
p + scale_color_manual("", values=clrs) + theme(legend.position = "none")

## ------------------------------------------------------------------------
p <- qplot(date, rate, data = rates.sub.m, geom = "line", colour = currency, linetype=I(2)) +
  scale_x_datetime(breaks = date_breaks("1 month"), labels = date_format("%b")) +
  scale_y_continuous("Standardized rates") 
p + geom_smooth() + scale_color_brewer(palette="Dark2")

## ---- echo=FALSE, fig.show='hide'----------------------------------------
library(forecast)
AUD.ts <- as.ts(rates$AUD, start=1, end=259)
AUD.ar <- ar(AUD.ts, newdata=AUD.ts)
AUD$resid <- as.numeric(AUD.ar$resid)
qplot(date, resid, data=AUD, geom="line")

## ---- echo=FALSE, fig.show='hide'----------------------------------------
AUD$weekday <- wday(AUD$date)
AUD$week <- week(AUD$date)
AUD_s <- AUD %>% group_by(week) %>% mutate(AUD_s = (AUD-mean(AUD)))
qplot(weekday, AUD_s, data=AUD_s, geom="line", group=week)

## ---- echo=FALSE, fig.show='hide'----------------------------------------
rates.sub2 <- t(scale(rates[,-c(1,13,18,22,36,115,152)]))
rates.hc <- hclust(dist(rates.sub2), method="ward.D2")
plot(rates.hc, hang=-1)
rates.t <- data.frame(rates.sub2)
rates.t$cl <- cutree(rates.hc, 3)
rates.cl <- data.frame(currency=rownames(rates.t), cl=rates.t$cl)
rates.sub2 <- data.frame(date=rates$date, scale(rates[,-c(1,13,18,22,36,115,152)])) 
rates.sub2.m <- gather(rates.sub2, currency, rate, -date)
rates.sub2.m <- merge(rates.sub2.m, rates.cl)

## ------------------------------------------------------------------------
qplot(date, rate, data=rates.sub2.m, group=currency, geom="line", alpha=I(0.5)) + 
  facet_wrap(~cl, ncol=3)

## ---- echo=FALSE---------------------------------------------------------
countries <- read_csv("http://dicook.github.io/Monash-R/data/countries.csv")
rates.countries <- merge(countries, rates.cl)

## ---- fig.height=4, fig.width=9, fig.show='hold'-------------------------
library(maps)
world <- map_data("world")
qplot(long, lat, data=world, group=group, order=order, geom="path") + theme_solid()
qplot(long, lat, data=world, group=group, order=order, geom="polygon",
      fill=I("grey70")) + theme_solid() 

## ---- fig.align='center', fig.show='hold'--------------------------------
rates.map <- merge(rates.countries, world, by.x="name", by.y="region")
rates.map$cl <- factor(rates.map$cl)
qplot(long, lat, data=rates.map, group=group, order=order, geom="polygon",
      fill=cl) + scale_fill_brewer(palette="Dark2") + 
  theme_solid() + theme(legend.position="None")

## ------------------------------------------------------------------------
p1 <- qplot(long, lat, data=subset(rates.map, cl==3), 
            group=group, order=order, geom="polygon",
      fill=I("#1B9E77")) + geom_path(data=world, colour="grey90") + 
  theme_solid() + theme(legend.position="None")
p2 <- qplot(date, rate, data=subset(rates.sub2.m, cl==3), group=currency, 
            geom="line", alpha=I(0.2), colour=I("#1B9E77")) + theme(legend.position="None")
p3 <- qplot(long, lat, data=subset(rates.map, cl==2), 
            group=group, order=order, geom="polygon",
      fill=I("#D95F02")) + geom_path(data=world, colour="grey90") +
  theme_solid() + theme(legend.position="None")
p4 <- qplot(date, rate, data=subset(rates.sub2.m, cl==2), group=currency, 
            geom="line", alpha=I(0.2), colour=I("#D95F02")) + theme(legend.position="None")

## ------------------------------------------------------------------------
library(gridExtra)
grid.arrange(p1, p2, p3, p4, ncol=2)

## ------------------------------------------------------------------------
library(ggmap)
melb <- get_map(location=c(144.9631, -37.8136))
ggmap(melb) + theme_solid()

## ------------------------------------------------------------------------
poll_loc <- read_csv("http://dicook.github.io/Monash-R/data/polling-places.csv")
ggmap(melb) + geom_point(data=poll_loc, aes(x=Long, y=Lat)) + theme_solid()

## ------------------------------------------------------------------------
internet <- read_csv("http://dicook.github.io/Monash-R/data/internet.csv")
qplot(`Social networks`, data=internet, geom="bar", binwidth=0.5) + 
  facet_grid(Gender~name)

## ------------------------------------------------------------------------
qplot(`Social networks`, data=internet, geom="bar", binwidth=0.5, fill=Gender) +
  facet_wrap(~name, ncol=5) + theme(legend.position="bottom")

## ------------------------------------------------------------------------
qplot(`Social networks`, data=internet, geom="bar", binwidth=0.5, 
      fill=Gender, position="dodge") + facet_wrap(~name, ncol=5) +
  theme(legend.position="bottom")

## ------------------------------------------------------------------------
grad <- read_csv("http://dicook.github.io/Monash-R/data/graduate-programs.csv")
qplot(subject, AvGREs, data=grad, geom="boxplot") 

## ----echo=FALSE----------------------------------------------------------
df <- data.frame(x=runif(100), y=runif(100), cl=sample(c(rep("A", 1), rep("B", 99))))
qplot(x, y, data=df, shape=cl) + theme_bw() + theme(legend.position="None", aspect.ratio=1)

## ----echo=FALSE----------------------------------------------------------
qplot(x, y, data=df, colour=cl) + theme_bw() + theme(legend.position="None", aspect.ratio=1)

## ---- echo=FALSE, fig.height=7, fig.width=12-----------------------------
display.brewer.all()

## ---- echo=FALSE---------------------------------------------------------
qplot(`Social networks`, data=internet, geom="bar", binwidth=0.5) + 
  facet_grid(Gender~name)

## ----echo=FALSE----------------------------------------------------------
internet.m.tb <- internet[,c(1,3,8)] %>%
                     group_by(name, Gender, `Social networks`) %>% 
                     tally(sort=TRUE) 
internet.m.tb <- subset(internet.m.tb, !is.na(`Social networks`))
internet.m.tb.n <- summarise(group_by(internet.m.tb, name, Gender), tot=sum(n)) 
internet.m.tb <- merge(internet.m.tb, internet.m.tb.n)
internet.m.tb.p <- summarise(group_by(internet.m.tb, name, Gender, `Social networks`), p=n/tot)

## ---- echo=FALSE---------------------------------------------------------
qplot(`Social networks`, p, data=internet.m.tb.p, geom="line", color=Gender) + 
  facet_wrap(~name, ncol=5) + theme(legend.position="bottom")

## ---- echo=FALSE---------------------------------------------------------
qplot(`Social networks`, p, data=internet.m.tb.p, geom="line", color=name) + 
  facet_wrap(~Gender, ncol=2) + theme(legend.position="bottom")

