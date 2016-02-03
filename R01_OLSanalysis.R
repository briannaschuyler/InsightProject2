library(ggplot2) # to use ggplot for nice graphics
library(asbio)

path='~/Documents/WL_DBdeets/'
setwd(path)

x=read.csv(paste(path,'06_DataFinal.csv',sep=''))
#x=read.csv(paste(path,'06_DataFinal3SDRemoved.csv',sep=''))

# Try removing data from variables where the slope flattens out 
# after a certain number.  (This is instead of fitting an x - x^2
# model since it's already log=transformed.)
x$NumberSignedUpFromCompany_i_log[x$NumberSignedUpFromCompany_i_log>log(30)]=NA
x$MeetingsTotalWeek0_i_log[x$MeetingsTotalWeek0_i_log>log(20)]=NA


log(30)
print(names(x))


###########################################################################
# Original regression with all variables
###########################################################################
fit0=lm(WeeksVisitedOutOf12~
          NumberSignedUpFromCompany_i_log+
          MeetingsTotalWeek0_i_log+
          PortionOfOrganizerWeek0_i_log+
          added_meetingWeek0_i_log+
          added_agenda_itemWeek0_i_log+
          assigned_action_itemWeek0_i_log, data=x,na.action='na.omit')
summary(fit0)


###########################################################################
# Regressions missing each of the 6 signficant variables
###########################################################################

fitNoNumberSignedUpFromCompany=lm(WeeksVisitedOutOf12~
          MeetingsTotalWeek0_i_log+
          PortionOfOrganizerWeek0_i_log+
          added_meetingWeek0_i_log+
          added_agenda_itemWeek0_i_log+
          assigned_action_itemWeek0_i_log, data=x,na.action='na.omit')
summary(fitNoNumberSignedUpFromCompany)

fitNoMeetingsTotalWeek0_i_log=lm(WeeksVisitedOutOf12~
          NumberSignedUpFromCompany_i_log+
          PortionOfOrganizerWeek0_i_log+
          added_meetingWeek0_i_log+
          added_agenda_itemWeek0_i_log+
          assigned_action_itemWeek0_i_log, data=x,na.action='na.omit')

fitNoPortionOfOrganizerWeek0_i_log=lm(WeeksVisitedOutOf12~
          NumberSignedUpFromCompany_i_log+
          MeetingsTotalWeek0_i_log+
          added_meetingWeek0_i_log+
          added_agenda_itemWeek0_i_log+
          assigned_action_itemWeek0_i_log, data=x,na.action='na.omit')

fitNoadded_meetingWeek0_i_log=lm(WeeksVisitedOutOf12~
                       NumberSignedUpFromCompany_i_log+
                       MeetingsTotalWeek0_i_log+
                       PortionOfOrganizerWeek0_i_log+
                       added_agenda_itemWeek0_i_log+
                       assigned_action_itemWeek0_i_log, data=x,na.action='na.omit')

fitNoadded_agenda_itemWeek0_i_log=lm(WeeksVisitedOutOf12~
          NumberSignedUpFromCompany_i_log+
          MeetingsTotalWeek0_i_log+
          PortionOfOrganizerWeek0_i_log+
          added_meetingWeek0_i_log+
          assigned_action_itemWeek0_i_log, data=x,na.action='na.omit')

fitNoassigned_action_itemWeek0_i_log=lm(WeeksVisitedOutOf12~
          NumberSignedUpFromCompany_i_log+
          MeetingsTotalWeek0_i_log+
          PortionOfOrganizerWeek0_i_log+
          added_meetingWeek0_i_log+
          added_agenda_itemWeek0_i_log, data=x,na.action='na.omit')

###########################################################################
# Now find the partial r^2 of each model and plot it to see what 
# contributes the most variance.
###########################################################################

v = c('NumberSignedUpFromCompany_i_log',
            'MeetingsTotalWeek0_i_log',
            'PortionOfOrganizerWeek0_i_log',
            'added_meetingWeek0_i_log',
            'added_agenda_itemWeek0_i_log',
            'assigned_action_itemWeek0_i_log')

vRnl = c('Number Signed Up \nFrom Company (< 30)',
              'Number of Weekly \nMeetings < 20)',
              'Portion Of Meetings \nOrganized',
              'Added Meeting to \nWorkLife',
              'Added agenda item to \nWorkLife Agenda',
              'Assigned Action Item to \nWorkLife Agenda')

vR = c('Number Signed Up From Company',
       'Number of Weekly Meetings',
       'Portion Of Meetings Organized',
       'Added Meeting to WorkLife',
       'Added agenda item to WorkLife Agenda',
       'Assigned Action Item to WorkLife Agenda')


r2df = data.frame(v = v, vR = vR, vRnl = vRnl)
r2df$r2[1] = partial.R2(fitNoNumberSignedUpFromCompany, fit0)
r2df$r2[2] = partial.R2(fitNoMeetingsTotalWeek0_i_log, fit0)
r2df$r2[3] = partial.R2(fitNoPortionOfOrganizerWeek0_i_log, fit0)
r2df$r2[4] = partial.R2(fitNoadded_meetingWeek0_i_log, fit0)
r2df$r2[5] = partial.R2(fitNoadded_agenda_itemWeek0_i_log, fit0)
r2df$r2[6] = partial.R2(fitNoassigned_action_itemWeek0_i_log, fit0)

r2df = r2df[with(r2df, order(-r2)), ]
rownames(r2df) <- 1:nrow(r2df)
# Change r2 to percentage
r2df$r2 = r2df$r2*100
ggplot(data=r2df, aes(x=vRnl, y=r2, fill = vR)) +
  geom_bar(stat="identity") +
  theme(legend.position="none", 
        axis.text.x = element_text(angle = 45, hjust = 1),
        text = element_text(size=20))+
  scale_x_discrete(limits=r2df$vRnl)+
  xlab('Variable Predicting Number of Weeks Using Product \n(out of 12 Weeks)')+
  ylab('Percentage of Retention Predicted \n(partial r squared)')
#  ylab(bquote('(partial '*~r^2*')'))
  #scale_x_discrete(limits=c(r2df$vR[1], r2df$vR[2], r2df$vR[3], r2df$vR[4], r2df$vR[5], r2df$vR[6]))

###########################################################################
# Now look at each of the scatter plots individually.
# They aren't going to look very good though, since the r^2 are actually
# pretty small.
###########################################################################

for(i in seq(6)){
  print(v[i])
  x$VOIlog = x[ ,v[i]]
  x$VOI = exp(x[ ,v[i]])-1
  VOIname=vR[i]

  y=ggplot(data=x, aes(x=VOI, y=WeeksVisitedOutOf12)) +
    geom_point(alpha = 1/5, colour='blue') +
    theme(legend.position="none", text = element_text(size=15))+
    #scale_x_log10()+
    #geom_smooth(method = lm, size=2, color='black')+
    geom_smooth(size=2, color='black')+
   # xlab(paste(VOIname,' \n(log-tranformed)',sep=''))+    
    xlab(paste(VOIname,'',sep=''))+
    ylab('Number of Weeks Product Used \n(Out of 12 Weeks)')
  ggsave(plot=y,height=4,width=6,dpi=200, filename=paste(path,'images/',v[i],'Loess.pdf',sep=''), useDingbats=FALSE)    

}


