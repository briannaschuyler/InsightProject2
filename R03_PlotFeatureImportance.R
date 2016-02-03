library(ggplot2) # to use ggplot for nice graphics

path='~/Documents/WL_DBdeets/'
setwd(path)

x=read.csv(paste(path,'RandomForestFeatureImportance.csv',sep=''))

x$fR[x$feature=='NumberSignedUpFromCompany_i_log'] = 'Number Signed Up \nFrom Company'
x$fR[x$feature=='AveNumAttendeesWeek0_i_log'] = 'Number of Attendees \nat Meetings'
x$fR[x$feature=='MeetingsTotalWeek0_i_log'] = 'Number of Weekly \nMeetings'
x$fR[x$feature=='PortionOfOrganizerWeek0_i_log'] = 'Portion Of Meetings \nOrganized'
x$fR[x$feature=='added_meetingWeek0_i_log'] = 'Added Meeting \nto WorkLife'
x$fR[x$feature=='added_agenda_itemWeek0_i_log'] = 'Added agenda item to \nWorkLife Agenda'
x$fR[x$feature=='assigned_action_itemWeek0_i_log'] = 'Assigned Action Item to \nWorkLife Agenda'
x$fR[x$feature=='EmailCorporateVsPrivate_log'] = 'Email Type'



y=ggplot(data=x, aes(x=fR, y=importance, fill = fR)) +
  geom_bar(stat="identity") +
  theme(legend.position="none", 
        axis.text.x = element_text(angle = 45, hjust = 1),
        text = element_text(size=20))+
  scale_x_discrete(limits=x$fR)+
  xlab('Variable Predicting User Retention \n(after 3 months)')+
  ylab('Feature Importance')

ggsave(plot=y,height=4,width=6,dpi=200, filename=paste(path,'images/FeatureImportance.pdf',sep=''), useDingbats=FALSE)    

