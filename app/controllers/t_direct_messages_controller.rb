#Slack System
#Direct Message Controller 
#Authorname-KyawSanWin@CyberMissions Myanmar Company limited 
#@Since 27/06/2019
#Version 1.0.0

class TDirectMessagesController < ApplicationController
    def show
        #check unlogin user
        checkuser

        session[:s_direct_message_id] =  params[:id]

        #call from ApplicationController for retrieve direct thread data
        retrieve_direct_thread

        #call from ApplicationController for retrieve home data
        retrievehome
    end

#20190916 Create by Myo Min Naing@CyberMissions Myanmar Company limited
    def edit
        #check unlogin user
        checkuser
        @s_user = MUser.find_by(id: session[:s_user_id])
        if @s_user.nil?
          redirect_to home_url
        else
          retrieve_direct_message
          #call from ApplicationController for retrieve home data
          retrievehome
        
          
        
    
          @direct_message = TDirectMessage.find_by(id: params[:id])
        end
      end
    
    
    def update
         #check unlogin user
         checkuser
    
         @s_user = MUser.find_by(id: session[:s_user_id])
         if @s_user .nil?
          redirect_to home_url
         else
          @direct_message = TDirectMessage.new(message_params)
    
          if @direct_message .directmsg == "" || @direct_message .directmsg.nil?
            flash[:danger] = "Message can't be blank."
            redirect_to directmsgedit_url(id: @direct_message.id)
          else 
            TDirectMessage.where(id: @direct_message.id).update_all(directmsg: @direct_message.directmsg)
            
            
            redirect_to @s_user
          end
         end
    end 
    
   

    def message_params
        params.require(:t_direct_message).permit(:id, :directmsg, :read_status,:send_user_id, :receive_user_id)
    end    
    
    private
    def redirect_cancel
      redirect_to my_page_path if params[:cancel]
    end
#20190916 Create by Myo Min Naing@CyberMissions Myanmar Company limited

end
