library(ggplot2) # to use ggplot for nice graphics
library(asbio)
library(plyr)
path='~/Documents/WL_DBdeets/'
setwd(path)

x=read.csv(paste(path,'06_DataFinal.csv',sep=''))

print(names(x))


hist(x$NumberSignedUpFromCompany[x$NumberSignedUpFromCompany<50], breaks=50)

x$varBin=NA
x$varBin[x$NumberSignedUpFromCompany<6]='05 or less'
x$varBin[x$NumberSignedUpFromCompany>5 & x$NumberSignedUpFromCompany<11]='06 to 10'
x$varBin[x$NumberSignedUpFromCompany>10 & x$NumberSignedUpFromCompany<21]='11 to 20'
x$varBin[x$NumberSignedUpFromCompany>20]='21+'

x$varBin=NA
x$varBin[x$NumberSignedUpFromCompany<5]='04 or less'
x$varBin[x$NumberSignedUpFromCompany>4 & x$NumberSignedUpFromCompany<9]='05 to 08'
x$varBin[x$NumberSignedUpFromCompany>8 & x$NumberSignedUpFromCompany<13]='08 to 12'
x$varBin[x$NumberSignedUpFromCompany>12 & x$NumberSignedUpFromCompany<21]='13 to 20'
x$varBin[x$NumberSignedUpFromCompany>21]='21+'


n=length(x$varBin[!is.na(x$varBin)])
sqrtn=sqrt(n)
xBin=ddply(x,~varBin,summarise,
           mean=mean(WeeksVisitedOutOf12, na.rm=TRUE),
           sd=sd(WeeksVisitedOutOf12, na.rm=TRUE),
           n=length(WeeksVisitedOutOf12))
xBin = xBin[which(!is.na(xBin$varBin)),]

###########################################################################
# Original regression with all variables
###########################################################################


v = c('NumberSignedUpFromCompany_i_log',
            'MeetingsTotalWeek0_i_log',
            'PortionOfOrganizerWeek0_i_log',
            'added_meetingWeek0_i_log',
            'added_agenda_itemWeek0_i_log',
            'assigned_action_itemWeek0_i_log')

# Define the top and bottom of the errorbars
limits <- aes(ymax = xBin$mean + xBin$sd/sqrt(xBin$n), ymin=xBin$mean - xBin$sd/sqrt(xBin$n))


ggplot(data=xBin, aes(x=varBin, y=mean, fill = varBin)) +
  geom_bar(stat="identity") +
  theme(legend.position="none", 
        axis.text.x = element_text(angle = 45, hjust = 1),
        text = element_text(size=20))+
  scale_x_discrete(limits=xBin$varBin)+
  geom_errorbar(limits, width=0.25)+
  xlab('Number of People Signed Up at Company')+
  ylab('Average Number of Weeks \n(Out of 12)')

