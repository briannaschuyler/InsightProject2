library(ggplot2) # to use ggplot for nice graphics
library(reshape)

path='~/Documents/WL_DBdeets/'
setwd(path)

# x=read.csv(paste(path,'04b_UserRegistrationDateForCohortPlot.csv',sep=''))
# drops <- c('X','reg_week','user_id')
# xm <- melt(x, id=c('registrationWeek'))
# names(xm) = c('registrationWeek','visitWeek','Count')

#write.csv(xm, paste(path,'04b_UserRegistrationDateForCohortPlotLong.csv', sep=''))

xm=read.csv(paste(path,'04b_UserRegistrationDateForCohortPlotLong.csv',sep=''))
#xm=read.csv(paste(path,'04b_UserRegistrationDateForCohortPlotLongJuneRemoved.csv',sep=''))


# Relabel the factors as dates.
xm$registrationWeek = as.Date(xm$registrationWeek, format = "%m/%d/%y")
xm$visitWeek = as.Date(xm$visitWeek, format = "%m/%d/%y")

# Drop the weeks 
# xm = xm[xm$registrationWeek != '2015-05-24' & 
#         xm$registrationWeek != '2015-05-31' &
#         xm$registrationWeek != '2015-06-07' &
#         xm$registrationWeek != '2015-06-14' &
#         xm$registrationWeek != '2015-06-21',]

xm$registrationWeek = as.Date(xm$registrationWeek, format = "%Y/%d/%y")
xm$visitWeek = as.Date(xm$visitWeek, format = "%m/%d/%y")

# For the rows in which there are no values, put 0
xm$Count[is.na(xm$Count)]=0

# This plots each cohort added on top of the last one.
ggplot(xm, aes(visitWeek)) + 
  geom_area(aes(y = Count, fill = registrationWeek, 
                group = registrationWeek)) + 
  theme(axis.text.x = element_text(angle = 30, hjust = 1),
        text = element_text(size=25), 
        panel.background = element_rect(fill = 'white', colour = 'black'),
        legend.position="none")+
  scale_x_date(breaks = "1 month") +
  xlab('Week')+
  ylab('Number of Users')
