# This script takes the output of the Random Forest Classifier in 
# scikit-learn and makes a nice plot of the feature importance.

library(ggplot2) # to use ggplot for nice graphics

path='~/Documents/WL_DBdeets/'
setwd(path)

x=read.csv(paste(path,'RandomForestFeatureImportance.csv',sep=''))

x$fR[x$feature=='NumberSignedUpFromCompany_i_log'] = 'Number Signed Up \nFrom Company'
x$fR[x$feature=='AveNumAttendeesWeek0_i_log'] = 'Number of Meeting \nAttendees'
x$fR[x$feature=='MeetingsTotalWeek0_i_log'] = 'Number of Weekly \nMeetings'
x$fR[x$feature=='PortionOfOrganizerWeek0_i_log'] = 'Portion Of Meetings \nOrganized'
x$fR[x$feature=='added_meetingWeek0_i_log'] = 'Added Meeting \nto Product'
x$fR[x$feature=='added_agenda_itemWeek0_i_log'] = 'Added item \nto Agenda'
x$fR[x$feature=='assigned_action_itemWeek0_i_log'] = 'Assigned Action \nItem to Agenda'
x$fR[x$feature=='EmailCorporateVsPrivate_log'] = 'Email Type'



y=ggplot(data=x, aes(x=fR, y=importance, fill = fR)) +
  geom_bar(stat="identity") +
  theme(legend.position="none", 
        axis.text.x = element_text(angle = 45, hjust = 1, color='black'),
        text = element_text(size=15))+
  scale_x_discrete(limits=x$fR)+
  xlab('Variable Predicting User Retention \n(after 3 months)')+
  ylab('Feature Importance')

ggsave(plot=y,height=5,width=8,dpi=200, filename=paste(path,'images/FeatureImportanceTemp.pdf',sep=''), useDingbats=FALSE)    

