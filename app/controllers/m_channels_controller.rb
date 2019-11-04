#Slack System
#Direct Message Controller 
#@Since 27/06/2019
#Version 1.0.0

class MChannelsController < ApplicationController
  
  #Authorname-MyoMinNaing@CyberMissions Myanmar Company limited 
  def new
    #check unlogin user
    checkuser

    session.delete(:s_user_id)
    session.delete(:s_channel_id)
    session.delete(:s_direct_message_id)
    session.delete(:s_group_message_id)
    
    #call from ApplicationController for retrieve home data
    retrievehome
  end

  #Authorname-KyawSanWin@CyberMissions Myanmar Company limited 
  def create
    #check unlogin user
    checkuser

    #call from ApplicationController for retrieve home data
    retrievehome

    if params[:session][:channel_name].nil? or params[:session][:channel_name] == ""
      flash[:danger] = "Channel Name can't be blank."
      render 'm_channels/new'
    else
      @m_channel = MChannel.new() 
      @m_channel.channel_status = params[:session][:channel_status]
      @m_channel.m_workspace_id = session[:workspace_id]
      @m_channel.channel_name = params[:session][:channel_name]
      
      if @m_channel.save
        @t_user_channel = TUserChannel.new
        @t_user_channel.message_count = 0
        @t_user_channel.unread_channel_message = nil
        @t_user_channel.created_admin = 1
        @t_user_channel.userid =session[:user_id]
        @t_user_channel.channelid = @m_channel.id

        if @t_user_channel.save
          flash[:success] = "Channel create Successful."
          redirect_to home_url
        end
      end
    end
  end

  #Authorname-KyawSanWin@CyberMissions Myanmar Company limited 
  def show
    #check unlogin user
    checkuser

    if MChannel.find_by(id: params[:id]).nil?
      redirect_to home_url
    else
      session.delete(:s_user_id)
      session.delete(:s_direct_message_id)
      session.delete(:s_group_message_id)
      session.delete(:r_direct_size)

      session[:s_channel_id] =  params[:id]

      session[:r_group_size] = 10

      #call from ApplicationController for retrieve group message data
      retrieve_group_message

      #call from ApplicationController for retrieve home data
      retrievehome
    end
  end

  #Authorname-KyawSanWin@CyberMissions Myanmar Company limited 
  def refresh_group
    #check unlogin user
    checkuser

    if MChannel.find_by(id: session[:s_channel_id]).nil?
      redirect_to home_url
    else
      if session[:r_group_size].nil?
        session[:r_group_size] =  10
      else
        session[:r_group_size] +=  10
      end

      #call from ApplicationController for retrieve group message data
      retrieve_group_message

      #call from ApplicationController for retrieve home data
      retrievehome
    end
  end

  #Authorname-MyoMinNaing@CyberMissions Myanmar Company limited 
  def edit
    #check unlogin user
    checkuser
    
    if MChannel.find_by(id: session[:s_channel_id]).nil?
      redirect_to home_url
    else
      #call from ApplicationController for retrieve home data
      retrievehome

      @m_channel = MChannel.find_by(id: params[:id])
    end
  end

  #Authorname-MyoMinNaing@CyberMissions Myanmar Company limited 
  def update
    #check unlogin user
    checkuser

    if MChannel.find_by(id: session[:s_channel_id]).nil?
      redirect_to home_url
    else
      @m_channel = MChannel.new(channel_params)

      if @m_channel.channel_name == "" or @m_channel.channel_name.nil?
        flash[:danger] = "Channel Name can't be blank."
        redirect_to channeledit_url(id: session[:s_channel_id])
      else 
        MChannel.where(id: @m_channel.id).update_all(channel_name: @m_channel.channel_name, channel_status: @m_channel.channel_status)
        flash[:success] = "Channel Update Successful."
        redirect_to home_url
      end
    end
  end

  def delete
    #check unlogin user
    checkuser

    if MChannel.find_by(id: session[:s_channel_id]).nil?
      redirect_to home_url
    else
      group_messges = TGroupMessage.where(m_channel_id: params[:id])

      group_messges.each do|gmsg|
        gpthread=TGroupThread.select("id").where(t_group_message_id: gmsg.id)

        gpthread.each do|gpthread|
          TGroupStarThread.where(groupthreadid: gpthread.id).destroy_all
          TGroupMentionThread.where(groupthreadid: gpthread.id).destroy_all
          TGroupThread.find_by(id: gpthread.id).destroy
        end

        TGroupStarMsg.where(groupmsgid: gmsg.id).destroy_all
        TGroupMentionMsg.where(groupmsgid: gmsg.id).destroy_all
        TGroupMessage.find_by(id: gmsg.id).delete
      end

      TUserChannel.where(channelid: params[:id]).destroy_all
      MChannel.find_by(id: params[:id]).delete

      flash[:success] = "Channel Delete Successful."
      redirect_to home_url
    end
  end

  #Authorname-KyawSanWin@CyberMissions Myanmar Company limited 
  def channel_params
    params.require(:m_channel).permit(:id, :channel_name, :channel_status)
  end
end
