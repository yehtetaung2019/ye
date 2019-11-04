#Slack System
#All Unread Controller 
#Authorname-NyiNyiMinThant@CyberMissions Myanmar Company limited 
#@Since 27/06/2019
#Version 1.0.0

class AllUnreadController < ApplicationController
    def show
        #check unlogin user
        checkuser
        
        session.delete(:s_user_id)
        session.delete(:s_channel_id)
        session.delete(:s_direct_message_id)
        session.delete(:s_group_message_id)
        session.delete(:r_direct_size)
        session.delete(:r_group_size)

        #Select unread direct messages from mysql database
        # yehtetaung close 20190920
        #@t_direct_messages=TDirectMessage.select("t_direct_messages.id,t_direct_messages.directmsg,t_direct_messages.created_at,m_users.name")
        #    .joins("INNER JOIN m_users ON m_users.id = t_direct_messages.send_user_id")
        #   .where("t_direct_messages.send_user_id=m_users.id and t_direct_messages.read_status=false and
        #        t_direct_messages.receive_user_id=?",session[:user_id]) 

        #Select unread direct thread messages from mysql database        
        #@t_direct_threads=TDirectThread.select("t_direct_threads.t_direct_message_id,
        #        t_direct_threads.directthreadmsg,t_direct_threads.created_at,m_users.name")
        #    .joins("INNER JOIN t_direct_messages ON t_direct_messages.id = t_direct_threads.t_direct_message_id
        #        INNER JOIN m_users ON m_users.id = t_direct_threads.m_user_id")
        #    .where("t_direct_messages.id=t_direct_threads.t_direct_message_id and t_direct_threads.read_status=false and t_direct_threads.m_user_id=m_users.id 
        #        and t_direct_threads.m_user_id <> ?",session[:user_id])
        # yehtetaung close 20190920
    
        #yehtetaung update 20190920
        @t_direct_messages=TDirectMessage.select("t_direct_messages.send_user_id,t_direct_messages.attachement,t_direct_messages.id,t_direct_messages.directmsg,t_direct_messages.created_at,m_users.name")
            .joins("INNER JOIN m_users ON m_users.id = t_direct_messages.send_user_id")
            .where("t_direct_messages.send_user_id=m_users.id and t_direct_messages.read_status=false and
                t_direct_messages.receive_user_id=?",session[:user_id]) 

        #Select unread direct thread messages from mysql database        
        @t_direct_threads=TDirectThread.select("t_direct_threads.m_user_id, t_direct_threads.id, t_direct_threads.attachement,t_direct_threads.t_direct_message_id,
        t_direct_threads.directthreadmsg,t_direct_threads.created_at,m_users.name")
        .joins("INNER JOIN t_direct_messages ON t_direct_messages.id = t_direct_threads.t_direct_message_id
        INNER JOIN m_users ON m_users.id = t_direct_threads.m_user_id")
        .where("t_direct_messages.id=t_direct_threads.t_direct_message_id and t_direct_threads.read_status=false and t_direct_threads.m_user_id=m_users.id 
        and t_direct_threads.m_user_id <> ?",session[:user_id])
     
        @thread_attachment = TDirectThread.select("t_direct_threads.id as id, attachement").
            where("t_direct_threads.attachement <> 'null' or t_direct_threads.attachement <> ''
            and t_direct_threads.m_user_id <> ?",session[:user_id])      
        #yehtetaung update 20190920

        #Select unread group messages from mysql database        
        @temp_user_channelids=TUserChannel.select("unread_channel_message").where("message_count > 0 and userid=?",session[:user_id])

        @t_user_channelids = Array.new
        @temp_user_channelids.each do |u_channel|
            unless u_channel.unread_channel_message.nil?
                @t_user_channelids = u_channel.unread_channel_message.split(",")
            end
        end
        
        @t_group_messages = TGroupMessage.select("t_group_messages.m_user_id,t_group_messages.id, t_group_messages.attachement, t_group_messages.groupmsg,t_group_messages.created_at,m_users.name,m_channels.channel_name, (select count(*) from t_group_threads where t_group_threads.t_group_message_id = t_group_messages.id) as count, m_channels.channel_name")
        .joins("INNER JOIN m_users ON m_users.id = t_group_messages.m_user_id
        INNER JOIN m_channels ON t_group_messages.m_channel_id=m_channels.id")
        #call from ApplicationController for retrieve home data
        retrievehome
        #TDirectMessage.where(receive_user_id: session[:user_id], read_status: 0).update_all(read_status: 1)
    end
end
