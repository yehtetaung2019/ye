 #20190916 Create by Myo Min Naing@CyberMissions Myanmar Company limited

 class TDirectThreadsController < ApplicationController

    def edit
        #check unlogin user
        checkuser
        @s_user = MUser.find_by(id: session[:s_user_id])
        if @s_user.nil?
          redirect_to home_url
        else
          #call from ApplicationController for retrieve home data
          retrievehome

          retrieve_direct_thread
        
    
          @direct_thread_message = TDirectThread.find_by(id: params[:id])
        end
      end
    
    
    def update
         #check unlogin user
         checkuser
    
         @s_user = MUser.find_by(id: session[:s_user_id])
         if @s_user .nil?
          redirect_to home_url
         else
            @direct_thread_message = TDirectThread.new(thread_params)
    
          if @direct_thread_message.directthreadmsg == "" || @direct_thread_message.directthreadmsg.nil?
            flash[:danger] = "Message can't be blank."
            redirect_to directthreadedit_url(id: @direct_thread_message.id)
          else 
            TDirectThread.where(id: @direct_thread_message.id).update_all(directthreadmsg: @direct_thread_message.directthreadmsg)
            
            @direct_message = TDirectMessage.find_by(id: @direct_thread_message.t_direct_message_id)
            redirect_to @direct_message
          end
         end
    end 
    
    private

    def thread_params
        params.require(:t_direct_thread).permit(:id, :directthreadmsg, :read_status,:t_direct_message_id, :m_user_id)
    end    
    
    def redirect_cancel
      redirect_to my_page_path if params[:cancel]
    end

end
 #20190916 Create by Myo Min Naing@CyberMissions Myanmar Company limited
