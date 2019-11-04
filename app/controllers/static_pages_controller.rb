#Slack System
#Direct Message Controller 
#@Since 27/06/2019
#Version 1.0.0

class StaticPagesController < ApplicationController
  #Authorname-KyawSanWin@CyberMissions Myanmar Company limited 
  def welcome
    #check login user
    checkloginuser
  end

  #Authorname-SuMyatPhyoe@CyberMissions Myanmar Company limited 
  def home
    #check unlogin user
    checkuser

    session.delete(:s_user_id)
    session.delete(:s_channel_id)
    session.delete(:s_direct_message_id)
    session.delete(:s_group_message_id)
    session.delete(:r_direct_size)
    session.delete(:r_group_size)
    
    #call from ApplicationController for retrieve home data
    retrievehome
  end
end
