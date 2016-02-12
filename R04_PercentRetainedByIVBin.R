# This script outputs graphs that show the average retention for different
# bins of each of the variables that help explain it.  It's in response
# to a request by the company to identify "Facebook numbers" - in other words,
# how many instances of specific variables do you need to ensure the user
# will stick around?  Ex. How many people at a person's company need to sign
# up for the service before it catches on?

library(ggplot2) # to use ggplot for nice graphics
library(asbio)
library(plyr)
path='~/Documents/WL_DBdeets/'
setwd(path)

x=read.csv(paste(path,'06_DataFinal.csv',sep=''))

#print(names(x))



###########################################################################
# Original regression with all variables
###########################################################################

plotRetentionBinnedVar <- function(df, varTitle, dvTitle){
  # Get stats on each bin for this variable.
  n=length(df$varBin[!is.na(df$varBin)])
  sqrtn=sqrt(n)
  
  #print(sqrtn)
  #print(x$dv[1:10])
  xBin=ddply(df,~varBin,summarise,
             mean=mean(dv, na.rm=TRUE),
             sd=sd(dv, na.rm=TRUE),
             n=length(dv))
  xBin = xBin[which(!is.na(xBin$varBin)),]
  print('Calculating upper and lower')
  upper = xBin$mean + xBin$sd/sqrt(xBin$n)
  lower = xBin$mean - xBin$sd/sqrt(xBin$n)
  # Define the top and bottom of the errorbars
  selimits <- aes(ymax = upper, ymin=lower)
  print('Plotting')
  y=ggplot(data=xBin, aes(x=varBin, y=mean, fill = varBin)) +
    geom_bar(stat="identity") +
     theme(legend.position="none", 
           axis.text.x = element_text(angle = 45, hjust = 1),
           text = element_text(size=15))+
     scale_x_discrete(limits=xBin$varBin)+
     geom_errorbar(selimits, width=0.25)+
     xlab(varTitle)+
     ylab(dvTitle)
  
  ggsave(plot=y,height=4,width=6,dpi=200, filename=paste(path,'images/',dvName,'ByBinned',varName,'.pdf',sep=''), useDingbats=FALSE)    
}


###########################################################################
# Split each variable of interest into bins and save the 
# Retention Plot
###########################################################################
x$dv=x$WeeksVisitedOutOf12
dvTitle='Average Number of Weeks \n(Out of 12)'
dvName='WeeksVisitedOutOf12'

#x$dv=x$RetentionStatus2Levels*100
#dvTitle='% Users Retained in 3rd Month'
#dvName='RetentionStatus2Levels'

######################################
# NumberSignedUpFromCompany
######################################
varTitle='Number of People Signed Up at Company'
varName='NumberSignedUpFromCompany'
hist(x$NumberSignedUpFromCompany[x$NumberSignedUpFromCompany<50], breaks=50)

x$varBin=NA
x$varBin[x$NumberSignedUpFromCompany<5]='04 or less'
x$varBin[x$NumberSignedUpFromCompany>4 & x$NumberSignedUpFromCompany<9]='05 to 08'
x$varBin[x$NumberSignedUpFromCompany>8 & x$NumberSignedUpFromCompany<13]='08 to 12'
x$varBin[x$NumberSignedUpFromCompany>12 & x$NumberSignedUpFromCompany<21]='13 to 20'
x$varBin[x$NumberSignedUpFromCompany>21]='21+'

##################
#################
df = x
n=length(df$varBin[!is.na(df$varBin)])
sqrtn=sqrt(n)

xBin=ddply(df,~varBin,summarise,
           mean=mean(dv, na.rm=TRUE),
           sd=sd(dv, na.rm=TRUE),
           n=length(dv))
xBin = xBin[which(!is.na(xBin$varBin)),]
print('Calculating upper and lower')
upper = xBin$mean + xBin$sd/sqrt(xBin$n)
lower = xBin$mean - xBin$sd/sqrt(xBin$n)
# Define the top and bottom of the errorbars
limits <- aes(ymax = upper, ymin=lower)
print('Plotting')
y=ggplot(data=xBin, aes(x=varBin, y=mean, fill = varBin)) +
  geom_bar(stat="identity") +
  theme(legend.position="none", 
        axis.text.x = element_text(angle = 45, hjust = 1),
        text = element_text(size=15))+
  scale_x_discrete(limits=xBin$varBin)+
  geom_errorbar(limits, width=0.25)+
  xlab(varTitle)+
  ylab(dvTitle)

ggsave(plot=y,height=4,width=6,dpi=200, filename=paste(path,'images/',dvName,'ByBinned',varName,'.pdf',sep=''), useDingbats=FALSE)    


######################################
# MeetingsTotalWeek0
######################################
varTitle='Number of Weekly Meetings'
varName='MeetingsTotalWeek0'
hist(x$MeetingsTotalWeek0[x$MeetingsTotalWeek0<50], breaks=50)

x$varBin=NA
x$varBin[x$MeetingsTotalWeek0<3]='02 or less'
x$varBin[x$MeetingsTotalWeek0>2 & x$MeetingsTotalWeek0<7]='03 to 06'
x$varBin[x$MeetingsTotalWeek0>5 & x$MeetingsTotalWeek0<11]='06 to 10'
x$varBin[x$MeetingsTotalWeek0>12 & x$MeetingsTotalWeek0<21]='13 to 20'
x$varBin[x$MeetingsTotalWeek0>20 & x$MeetingsTotalWeek0<31]='21 to 30'
x$varBin[x$MeetingsTotalWeek0>30]='31+'

##################
#################
df = x
n=length(df$varBin[!is.na(df$varBin)])
sqrtn=sqrt(n)

xBin=ddply(df,~varBin,summarise,
           mean=mean(dv, na.rm=TRUE),
           sd=sd(dv, na.rm=TRUE),
           n=length(dv))
xBin = xBin[which(!is.na(xBin$varBin)),]
print('Calculating upper and lower')
upper = xBin$mean + xBin$sd/sqrt(xBin$n)
lower = xBin$mean - xBin$sd/sqrt(xBin$n)
# Define the top and bottom of the errorbars
limits <- aes(ymax = upper, ymin=lower)
print('Plotting')
y=ggplot(data=xBin, aes(x=varBin, y=mean, fill = varBin)) +
  geom_bar(stat="identity") +
  theme(legend.position="none", 
        axis.text.x = element_text(angle = 45, hjust = 1),
        text = element_text(size=15))+
  scale_x_discrete(limits=xBin$varBin)+
  geom_errorbar(limits, width=0.25)+
  xlab(varTitle)+
  ylab(dvTitle)

ggsave(plot=y,height=4,width=6,dpi=200, filename=paste(path,'images/',dvName,'ByBinned',varName,'.pdf',sep=''), useDingbats=FALSE)    

######################################
# PortionOfOrganizerWeek0
######################################
varTitle='Portion of Meetings For Which\n User is Organizer'
varName='PortionOfOrganizerWeek0'
hist(x$PortionOfOrganizerWeek0[x$PortionOfOrganizerWeek0<50], breaks=50)

x$varBin=NA
x$varBin[x$PortionOfOrganizerWeek0<.25]='25% or less'
x$varBin[x$PortionOfOrganizerWeek0>.24 & x$PortionOfOrganizerWeek0<.5]='25% to 50%'
x$varBin[x$PortionOfOrganizerWeek0>.49 & x$PortionOfOrganizerWeek0<.75]='50% to 75%'
x$varBin[x$PortionOfOrganizerWeek0>.75]='75% to %100'

##################
#################
df = x
n=length(df$varBin[!is.na(df$varBin)])
sqrtn=sqrt(n)

xBin=ddply(df,~varBin,summarise,
           mean=mean(dv, na.rm=TRUE),
           sd=sd(dv, na.rm=TRUE),
           n=length(dv))
xBin = xBin[which(!is.na(xBin$varBin)),]
print('Calculating upper and lower')
upper = xBin$mean + xBin$sd/sqrt(xBin$n)
lower = xBin$mean - xBin$sd/sqrt(xBin$n)
# Define the top and bottom of the errorbars
limits <- aes(ymax = upper, ymin=lower)
print('Plotting')
y=ggplot(data=xBin, aes(x=varBin, y=mean, fill = varBin)) +
  geom_bar(stat="identity") +
  theme(legend.position="none", 
        axis.text.x = element_text(angle = 45, hjust = 1),
        text = element_text(size=15))+
  scale_x_discrete(limits=xBin$varBin)+
  geom_errorbar(limits, width=0.25)+
  xlab(varTitle)+
  ylab(dvTitle)

ggsave(plot=y,height=4,width=6,dpi=200, filename=paste(path,'images/',dvName,'ByBinned',varName,'.pdf',sep=''), useDingbats=FALSE)    

######################################
# added_meetingWeek0
######################################
varTitle='Added Meeting in Week 0'
varName='added_meetingWeek0'
hist(x$added_meetingWeek0[x$added_meetingWeek0<50], breaks=50)

x$varBin=NA
x$varBin[x$added_meetingWeek0==0]='0'
x$varBin[x$added_meetingWeek0==1]='1'
x$varBin[x$added_meetingWeek0==2]='2'
x$varBin[x$added_meetingWeek0==3]='3'
x$varBin[x$added_meetingWeek0>3]='4+'

##################
#################
df = x
n=length(df$varBin[!is.na(df$varBin)])
sqrtn=sqrt(n)

xBin=ddply(df,~varBin,summarise,
           mean=mean(dv, na.rm=TRUE),
           sd=sd(dv, na.rm=TRUE),
           n=length(dv))
xBin = xBin[which(!is.na(xBin$varBin)),]
print('Calculating upper and lower')
upper = xBin$mean + xBin$sd/sqrt(xBin$n)
lower = xBin$mean - xBin$sd/sqrt(xBin$n)
# Define the top and bottom of the errorbars
limits <- aes(ymax = upper, ymin=lower)
print('Plotting')
y=ggplot(data=xBin, aes(x=varBin, y=mean, fill = varBin)) +
  geom_bar(stat="identity") +
  theme(legend.position="none", 
        axis.text.x = element_text(angle = 45, hjust = 1),
        text = element_text(size=15))+
  scale_x_discrete(limits=xBin$varBin)+
  geom_errorbar(limits, width=0.25)+
  xlab(varTitle)+
  ylab(dvTitle)

ggsave(plot=y,height=4,width=6,dpi=200, filename=paste(path,'images/',dvName,'ByBinned',varName,'.pdf',sep=''), useDingbats=FALSE)    

######################################
# added_meetingWeek0
######################################
varTitle='Added Agenda Item in Week 0'
varName='added_agenda_itemWeek0'
hist(x$added_agenda_itemWeek0[x$added_agenda_itemWeek0<50], breaks=50)

x$varBin=NA
x$varBin[x$added_agenda_itemWeek0<5]='0 to 5'
x$varBin[x$added_agenda_itemWeek0>4 & x$added_agenda_itemWeek0<11]='05 to 010'
x$varBin[x$added_agenda_itemWeek0>10 & x$added_agenda_itemWeek0<16]='11 to 15'
x$varBin[x$added_agenda_itemWeek0>15 & x$added_agenda_itemWeek0<21]='16 to 20'
x$varBin[x$added_agenda_itemWeek0>20 & x$added_agenda_itemWeek0<26]='21 to 25'
x$varBin[x$added_agenda_itemWeek0>25]='26+'

##################
#################
df = x
n=length(df$varBin[!is.na(df$varBin)])
sqrtn=sqrt(n)

xBin=ddply(df,~varBin,summarise,
           mean=mean(dv, na.rm=TRUE),
           sd=sd(dv, na.rm=TRUE),
           n=length(dv))
xBin = xBin[which(!is.na(xBin$varBin)),]
print('Calculating upper and lower')
upper = xBin$mean + xBin$sd/sqrt(xBin$n)
lower = xBin$mean - xBin$sd/sqrt(xBin$n)
# Define the top and bottom of the errorbars
limits <- aes(ymax = upper, ymin=lower)
print('Plotting')
y=ggplot(data=xBin, aes(x=varBin, y=mean, fill = varBin)) +
  geom_bar(stat="identity") +
  theme(legend.position="none", 
        axis.text.x = element_text(angle = 45, hjust = 1),
        text = element_text(size=15))+
  scale_x_discrete(limits=xBin$varBin)+
  geom_errorbar(limits, width=0.25)+
  xlab(varTitle)+
  ylab(dvTitle)

ggsave(plot=y,height=4,width=6,dpi=200, filename=paste(path,'images/',dvName,'ByBinned',varName,'.pdf',sep=''), useDingbats=FALSE)    

######################################
# added_meetingWeek0
######################################
varTitle='Assigned Action Item to Agenda in Week 0'
varName='assigned_action_itemWeek0'
hist(x$assigned_action_itemWeek0[x$assigned_action_itemWeek0<50], breaks=50)

x$varBin=NA
x$varBin[x$assigned_action_itemWeek0==0]='0'
x$varBin[x$assigned_action_itemWeek0==1]='1'
x$varBin[x$assigned_action_itemWeek0==2]='2'
x$varBin[x$assigned_action_itemWeek0==3]='3'
x$varBin[x$assigned_action_itemWeek0==4]='4'
x$varBin[x$assigned_action_itemWeek0>4]='5+'

##################
#################
df = x
n=length(df$varBin[!is.na(df$varBin)])
sqrtn=sqrt(n)

xBin=ddply(df,~varBin,summarise,
           mean=mean(dv, na.rm=TRUE),
           sd=sd(dv, na.rm=TRUE),
           n=length(dv))
xBin = xBin[which(!is.na(xBin$varBin)),]
print('Calculating upper and lower')
upper = xBin$mean + xBin$sd/sqrt(xBin$n)
lower = xBin$mean - xBin$sd/sqrt(xBin$n)
# Define the top and bottom of the errorbars
limits <- aes(ymax = upper, ymin=lower)
print('Plotting')
y=ggplot(data=xBin, aes(x=varBin, y=mean, fill = varBin)) +
  geom_bar(stat="identity") +
  theme(legend.position="none", 
        axis.text.x = element_text(angle = 45, hjust = 1),
        text = element_text(size=15))+
  scale_x_discrete(limits=xBin$varBin)+
  geom_errorbar(limits, width=0.25)+
  xlab(varTitle)+
  ylab(dvTitle)

ggsave(plot=y,height=4,width=6,dpi=200, filename=paste(path,'images/',dvName,'ByBinned',varName,'.pdf',sep=''), useDingbats=FALSE)    



