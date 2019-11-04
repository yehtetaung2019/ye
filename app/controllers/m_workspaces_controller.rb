#Slack System
#Direct Message Controller 
#Authorname-AyeMyatHnin@CyberMissions Myanmar Company limited 
#@Since 27/06/2019
#Version 1.0.0

class MWorkspacesController < ApplicationController
    def new
        #check login user
        checkloginuser
        
        @m_user = MUser.new
    end
    #Thu Zin TUn 27082019
    def changeworkspacename
        retrievehome
    end
    def change 
         workspacename = params[:session][:name]
          if workspacename == "" || workspacename.nil?
            flash[:danger] = "Workspace Name can't be blank."
            redirect_to change_workspacename_url
          else 
            MWorkspace.where(id: session[:workspace_id]).update_all(workspace_name: workspacename)
            flash[:success] = "Workspace Name Successful."
            redirect_to home_url
          end
    end
    def delete
        #check unlogin user
        checkuser
    
        if MWorkspace.find_by(id: session[:workspace_id]).nil?
          redirect_to home_url
        else 
          TUserWorkspace.where(workspaceid: session[:workspace_id]).destroy_all
          MWorkspace.find_by(id: session[:workspace_id]).delete
          MUser.find_by(id:session[:user_id]).delete
            @all_channels = MChannel.where(m_workspace_id: session[:workspace_id])
            @all_channels.each do|channel|
              if channel.id
                group_messges = TGroupMessage.where(m_channel_id: channel.id)
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
                TUserChannel.where(channelid: channel.id).destroy_all 
                MChannel.where(id: channel.id).delete
            end
            end
            flash[:success] = "Workspace Delete Successful."
            redirect_to logout_path  
        end
      end  
    #Thu Zin TUn 27082019 
end
