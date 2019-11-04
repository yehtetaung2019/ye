#Slack System
#Application Controller 
#@Since 27/06/2019
#Version 1.0.0

class ApplicationController < ActionController::Base
protect_from_forgery with: :exception
  include SessionsHelper

  
  #Authorname-SuMyatPhyoe@CyberMissions Myanmar Company limited 
  def retrievehome
    #Message Profile Yin Yin Aye
    @msg_profiles = UserInfo.all  
    #Message Profile Yin Yin Aye
    #Profile Yin Yin Aye@CyberMissions Myanmar Company limited 
    @user_info = UserInfo.find_by(user_id: session[:user_id])
    #Profile Yin Yin Aye@CyberMissions Myanmar Company limited 
    @m_workspace = MWorkspace.find_by(id: session[:workspace_id])
    @m_user = MUser.find_by(id: session[:user_id])
    #Yin Yin Aye@CyberMissions Myanmar Company limited 
    @m_attachment =  MUser.where("m_users.attachment <> 'null' or m_users.attachment <> ''
    and m_users.id = ?", session[:user_id])
    #Yin Yin Aye@CyberMissions Myanmar Company limited 
    
    @m_users = MUser.joins("INNER JOIN t_user_workspaces ON t_user_workspaces.userid = m_users.id
                            INNER JOIN m_workspaces ON m_workspaces.id = t_user_workspaces.workspaceid")
      .where("m_users.member_status = true and m_workspaces.id = ?", session[:workspace_id])

    @m_channels = MChannel.select("m_channels.id,channel_name,channel_status,t_user_channels.message_count").joins(
      "INNER JOIN t_user_channels ON t_user_channels.channelid = m_channels.id"
    ).where("(m_channels.m_workspace_id = ? and t_user_channels.userid = ?)",session[:workspace_id], session[:user_id]).order(id: :asc)

    @m_p_channels = MChannel.select("m_channels.id,channel_name,channel_status")
      .where("(m_channels.channel_status = true and m_channels.m_workspace_id = ?)",session[:workspace_id]).order(id: :asc)
           
    @direct_msgcounts = Array.new

    @m_users.each do |muser|
      @direct_count = TDirectMessage.where(send_user_id: muser.id, receive_user_id: session[:user_id], read_status: false)
  
      @thread_count = TDirectThread.joins("INNER JOIN t_direct_messages ON t_direct_messages.id = t_direct_threads.t_direct_message_id")
                                    .where("t_direct_threads.read_status = false and t_direct_threads.m_user_id = ? and 
                                    ((t_direct_messages.send_user_id = ? and t_direct_messages.receive_user_id = ?) or 
                                    (t_direct_messages.send_user_id = ? and t_direct_messages.receive_user_id = ?))", 
                                    muser.id, muser.id, session[:user_id], session[:user_id], muser.id)
      @direct_msgcounts.push( @direct_count.size +  @thread_count.size)
    end

    @all_unread_count = 0
    @m_channels.each do |c|
      @all_unread_count += c.message_count
    end

    @direct_msgcounts.each do |c|
      @all_unread_count +=c
    end

    @m_channelsids = Array.new
    @m_channels.each do|m_channel|
      @m_channelsids.push(m_channel.id)
    end
  end

  #Authorname-KyawSanWin@CyberMissions Myanmar Company limited 
  def retrieve_direct_message
    TDirectMessage.where(send_user_id: session[:s_user_id], receive_user_id: session[:user_id], read_status: false).update_all(read_status: true)
    TDirectThread.joins("INNER JOIN t_direct_messages ON t_direct_messages.id = t_direct_threads.t_direct_message_id").where(
      "(t_direct_messages.receive_user_id = ? and t_direct_messages.send_user_id = ? ) or (t_direct_messages.receive_user_id = ? and t_direct_messages.send_user_id = ? )", session[:user_id],  session[:s_user_id],  session[:s_user_id], session[:user_id]
    ).where.not(m_user_id: session[:user_id], read_status: true).update_all(read_status: true)
    
    @s_user = MUser.find_by(id: session[:s_user_id])
    
    #Profile Yin Yin Aye@CyberMissions Myanmar Company limited 
    @s_user_info = UserInfo.find_by(user_id: session[:s_user_id])
    #Profile Yin Yin Aye@CyberMissions Myanmar Company limited 

    #Update Myo Min Naing@CyberMissions Myanmar Company limited 
    @t_direct_messages = TDirectMessage.select("name, directmsg,t_direct_messages.read_status, t_direct_messages.attachement, t_direct_messages.send_user_id, t_direct_messages.id as id, t_direct_messages.created_at  as created_at, 
                        (select count(*) from t_direct_threads where t_direct_threads.t_direct_message_id = t_direct_messages.id) as count")
                        .joins("INNER JOIN m_users ON m_users.id = t_direct_messages.send_user_id")
                        .where("(t_direct_messages.receive_user_id = ? and t_direct_messages.send_user_id = ? ) 
                        or (t_direct_messages.receive_user_id = ? and t_direct_messages.send_user_id = ? )", 
                        session[:user_id],  session[:s_user_id],  session[:s_user_id], session[:user_id]).order(created_at: :desc).limit(session[:r_direct_size])
    #Update Myo Min Naing@CyberMissions Myanmar Company limited 


    #@t_direct_messages = TDirectMessage.select("name,send_user_id, directmsg, t_direct_messages.id as id,t_direct_messages.attachement, t_direct_messages.created_at  as created_at, 
    #                                      (select count(*) from t_direct_threads where t_direct_threads.t_direct_message_id = t_direct_messages.id) as count")
    #                                    .joins("INNER JOIN m_users ON m_users.id = t_direct_messages.send_user_id")
    #                                    .where("(t_direct_messages.receive_user_id = ? and t_direct_messages.send_user_id = ? ) 
    #                                      or (t_direct_messages.receive_user_id = ? and t_direct_messages.send_user_id = ? )", 
    #                                      session[:user_id],  session[:s_user_id], session[:s_user_id], session[:user_id]).order(created_at: :desc).limit(session[:r_direct_size])
    
    #yehtetaung
    @attachment = TDirectMessage.select("t_direct_messages.id as id, attachement").
    where("t_direct_messages.attachement <> 'null' or t_direct_messages.attachement <> ''
    and t_direct_messages.send_user_id = ?", session[:user_id])
    #yehtetaung
    @t_direct_messages = @t_direct_messages.reverse
    @temp_direct_star_msgids = TDirectStarMsg.select("directmsgid").where("userid = ?", session[:user_id])

    @t_direct_star_msgids = Array.new
    @temp_direct_star_msgids.each { |r| @t_direct_star_msgids.push(r.directmsgid) }

    #20191021 chonweaung delete start
    #@t_direct_message_dates = TDirectMessage.select("distinct DATE(created_at) as created_date")
    #                                        .where("(t_direct_messages.receive_user_id = ? and t_direct_messages.send_user_id = ? ) 
    #                                        or (t_direct_messages.receive_user_id = ? and t_direct_messages.send_user_id = ? )", 
    #                                        session[:user_id],  session[:s_user_id],  session[:s_user_id], session[:user_id])
    
    #@t_direct_message_datesize = Array.new
    #@t_direct_messages.each{|d| @t_direct_message_datesize.push(d.created_at.strftime("%F").to_s)}
    #20191021 chonweaung delete end

    #Thu Zin Tun 
      @time_d=((Time.now).to_i - (@s_user.updated_at).utc.to_i) 
      @time_day=((Time.now).to_i - (@s_user.updated_at).to_i) / 3600
    #Thu Zin Tun
  end

  #Authorname-KyawSanWin@CyberMissions Myanmar Company limited 
  def retrieve_direct_thread
    @s_user = MUser.find_by(id: session[:s_user_id])
        
    @t_direct_message = TDirectMessage.find_by(id: session[:s_direct_message_id])
    @send_user = MUser.find_by(id: @t_direct_message.send_user_id)

    TDirectThread.where.not(m_user_id: session[:user_id], read_status: true).update_all(read_status: true)
    #Update Myo Min Naing@CyberMissions Myanmar Company limited 
    #@t_direct_threads = TDirectThread.select("name, t_direct_threads.read_status, t_direct_threads.m_user_id, directthreadmsg, t_direct_threads.attachement, t_direct_threads.id as id, t_direct_threads.created_at  as created_at")
    #            .joins("INNER JOIN t_direct_messages ON t_direct_messages.id = t_direct_threads.t_direct_message_id
    #                    INNER JOIN m_users ON m_users.id = t_direct_threads.m_user_id")
    #            .where("t_direct_threads.t_direct_message_id = ?", session[:s_direct_message_id]).order(id: :asc)
    #Update Myo Min Naing@CyberMissions Myanmar Company limited 

    @t_direct_threads = TDirectThread.select("name, t_direct_threads.read_status, directthreadmsg,t_direct_threads.m_user_id, t_direct_threads.attachement, t_direct_threads.id as id, t_direct_threads.created_at  as created_at")
               .joins("INNER JOIN t_direct_messages ON t_direct_messages.id = t_direct_threads.t_direct_message_id
                       INNER JOIN m_users ON m_users.id = t_direct_threads.m_user_id")
               .where("t_direct_threads.t_direct_message_id = ?", session[:s_direct_message_id]).order(id: :asc)
    #yehtetaung
    @attachment = TDirectThread.select("t_direct_threads.id as id, attachement").
    where("t_direct_threads.attachement <> 'null' or t_direct_threads.attachement <> ''
    and t_direct_threads.m_user_id = ?", session[:user_id])
    #yehtetaung  
    @temp_direct_star_thread_msgids = TDirectStarThread.select("directthreadid").where("userid = ?", session[:user_id])

    @t_direct_star_thread_msgids = Array.new
    @temp_direct_star_thread_msgids.each { |r| @t_direct_star_thread_msgids.push(r.directthreadid) }
  end

  #Authorname-KyawSanWin@CyberMissions Myanmar Company limited 
  def retrieve_group_message
    @s_channel = MChannel.find_by(id: session[:s_channel_id])

    @m_channel_users = MUser.joins("INNER JOIN t_user_channels on t_user_channels.userid = m_users.id 
                                    INNER JOIN m_channels ON m_channels.id = t_user_channels.channelid")
                                .where("m_users.member_status = true and m_channels.m_workspace_id = ? and m_channels.id = ?",
                                session[:workspace_id], session[:s_channel_id])
                      #ye htet aung 20191004 add          
                      @names = []
                      @m_channel_users.each do |name|
                        @names << name.name
                      end
                      #ye htet aung 20191004 add 
    TUserChannel.where(channelid: session[:s_channel_id], userid: session[:user_id]).update_all(message_count: 0, unread_channel_message: nil)

    @t_group_messages = TGroupMessage.select("name, groupmsg,t_group_messages.m_user_id, t_group_messages.attachement, t_group_messages.id as id, t_group_messages.created_at as created_at, 
                                            (select count(*) from t_group_threads where t_group_threads.t_group_message_id = t_group_messages.id) as count ")
                                      .joins("INNER JOIN m_users ON m_users.id = t_group_messages.m_user_id")
                                      .where("m_channel_id = ? ", session[:s_channel_id]).order(created_at: :desc).limit(session[:r_group_size])
    
    #yehtetaung
    @attachment = TGroupMessage.select("t_group_messages.id as id, attachement").
                  where("t_group_messages.attachement <> 'null' or t_group_messages.attachement <> ''
                  and t_group_messages.m_channel_id = ?", session[:s_channel_id])
    #yehtetaung
    @t_group_messages = @t_group_messages.reverse
    @temp_group_star_msgids = TGroupStarMsg.select("groupmsgid").where("userid = ?", session[:user_id])

    @t_group_star_msgids = Array.new
    @temp_group_star_msgids.each { |r| @t_group_star_msgids.push(r.groupmsgid) }
    @u_count = TUserChannel.where(channelid: session[:s_channel_id]).count
    @t_group_message_dates = TGroupMessage.select("distinct DATE(created_at) as created_date").where("m_channel_id = ? ", session[:s_channel_id])
    
    @t_group_message_datesize = Array.new
    @t_group_messages.each{|d| @t_group_message_datesize.push(d.created_at.strftime("%F").to_s)}
    #Update Myo Min Naing@CyberMissions Myanmar Company limited 
        @ch_un = TUserChannel.where("channelid=? and userid <> ?",session[:s_channel_id], session[:user_id])
        @ch_un_status = Array.new
        @t_group_messages.each do |groupmsg|
          @ch_un.each do |u_ch|
            unless u_ch.unread_channel_message.nil?
              @msgidary = Array.new
              @msgidary = u_ch.unread_channel_message.split(",").map{|chr| chr.to_i}
              unless @msgidary.include?(groupmsg.id)
                @ch_un_status << groupmsg.id
                break  
              end
            else
              @ch_un_status << groupmsg.id
            end 
          end
        end 
      #Update Myo Min Naing@CyberMissions Myanmar Company limited    
  end

  #Authorname-KyawSanWin@CyberMissions Myanmar Company limited 
  def retrieve_group_thread
    @s_channel = MChannel.find_by(id: session[:s_channel_id])

    @m_channel_users = MUser.joins("INNER JOIN t_user_channels on t_user_channels.userid = m_users.id 
                                    INNER JOIN m_channels ON m_channels.id = t_user_channels.channelid")
                                .where("m_users.member_status = true and m_channels.m_workspace_id = ? and m_channels.id = ?",
                                session[:workspace_id], session[:s_channel_id])
    #ye htet aung 20191004 add          
      @names = []
      @m_channel_users.each do |name|
      @names << name.name
      end
    #ye htet aung 20191004 add 
                                
    TUserChannel.where(channelid: session[:s_channel_id], userid: session[:user_id]).update_all(message_count: 0, unread_channel_message: nil)
    
    @t_group_message = TGroupMessage.find_by(id: session[:s_group_message_id])
    @send_user = MUser.find_by(id: @t_group_message.m_user_id)
    #Message Profile Yin Yin Aye
    @t_group_threads = TGroupThread.select("name, t_group_threads.m_user_id, groupthreadmsg, t_group_threads.id as id, t_group_threads.created_at  as created_at")
                    .joins("INNER JOIN t_group_messages ON t_group_messages.id = t_group_threads.t_group_message_id
                          INNER JOIN m_users ON m_users.id = t_group_threads.m_user_id").where("t_group_threads.t_group_message_id = ?", session[:s_group_message_id]).order(id: :asc)
    #Message Profile Yin Yin Aye

    #@t_group_threads = TGroupThread.select("name, groupthreadmsg,t_group_threads.m_user_id, t_group_threads.attachement, t_group_threads.id as id, t_group_threads.created_at  as created_at")
    #                .joins("INNER JOIN t_group_messages ON t_group_messages.id = t_group_threads.t_group_message_id
    #                      INNER JOIN m_users ON m_users.id = t_group_threads.m_user_id").where("t_group_threads.t_group_message_id = ?", session[:s_group_message_id]).order(id: :asc)
    #yehtetaung
    @attachment = TGroupThread.select("t_group_threads.id as id, attachement").
                  where("t_group_threads.attachement <> 'null' or t_group_threads.attachement <> ''
                  and t_group_threads.m_user_id = ?", session[:user_id])
    #yehtetaung
    @temp_group_star_thread_msgids = TGroupStarThread.select("groupthreadid").where("userid = ?", session[:user_id])

    @t_group_star_thread_msgids = Array.new
    @temp_group_star_thread_msgids.each { |r| @t_group_star_thread_msgids.push(r.groupthreadid) }
    
    @u_count = TUserChannel.where(channelid: session[:s_channel_id]).count
  end

  #Authorname-KyawSanWin@CyberMissions Myanmar Company limited 
  def checkuser
    if session[:workspace_id].nil?
        redirect_to root_url
    else
      m_user = MUser.find_by(id: session[:user_id], member_status: true)
      if m_user.nil?
        session.delete(:workspace_id)
        session.delete(:s_channel_id)
        session.delete(:s_user_id)
        session.delete(:s_direct_message_id)
        session.delete(:s_group_message_id)
        
        flash.clear
        #CNA
        MUser.where(id: session[:user_id]).update_all(active_status: false)
        #CNA
        log_out if logged_in?
        redirect_to root_url
      end
    end
  end

  #Authorname-KyawSanWin@CyberMissions Myanmar Company limited 
  def checkloginuser
    unless session[:workspace_id].nil?
      redirect_to home_url
    end
  end
end
