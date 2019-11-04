#Slack System
#Direct Message Controller 
#Authorname-KyawSanWin@CyberMissions Myanmar Company limited 
#@Since 27/06/2019
#Version 1.0.0

class TGroupMessagesController < ApplicationController
  def show
    #check unlogin user
    checkuser

    
    if session[:s_channel_id].nil?
      redirect_to home_url
    elsif MChannel.find_by(id: session[:s_channel_id]).nil?
      redirect_to home_url
    else
      session[:s_group_message_id] =  params[:id]

      #call from ApplicationController for retrieve group thread data
      retrieve_group_thread

      #call from ApplicationController for retrieve home data
      retrievehome
    end
  end

   #20190916 Create by Myo Min Naing@CyberMissions Myanmar Company limited
   def edit
    #check unlogin user
    checkuser
    @m_channel = MChannel.find_by(id: session[:s_channel_id])
    if @m_channel.nil?
      redirect_to home_url
    else
      #call from ApplicationController for retrieve home data
      retrievehome

      retrieve_group_message

      @group_message = TGroupMessage.find_by(id: params[:id])
    end
  end


  def update
     #check unlogin user
     checkuser

     @m_channel = MChannel.find_by(id: session[:s_channel_id])
     if @m_channel.nil?
      redirect_to home_url
     else
      @group_message = TGroupMessage.new(message_params)

      if @group_message .groupmsg == "" || @group_message .groupmsg.nil?
        flash[:danger] = "Channel Message can't be blank."
        redirect_to channelmsgedit_url(id: @group_message.id)
      else 
        TGroupMessage.where(id: @group_message.id).update_all(groupmsg: @group_message.groupmsg)
        
        redirect_to @m_channel
      end
     end
  end 

  private

    def message_params
      params.require(:t_group_message).permit(:id, :groupmsg, :m_channel_id,:m_user_id)
    end


    def redirect_cancel
      redirect_to my_page_path if params[:cancel]
    end
   #20190916 Create by Myo Min Naing@CyberMissions Myanmar Company limited
end
