 #20190916 Create by Myo Min Naing@CyberMissions Myanmar Company limited
 class TGroupThreadsController < ApplicationController
    def edit
      #check unlogin user
      checkuser
      @m_channel = MChannel.find_by(id: session[:s_channel_id])
      if @m_channel.nil?
        redirect_to home_url
      else
        
        retrieve_group_thread
        #call from ApplicationController for retrieve home data
        retrievehome
  
        
      
  
        @group_thread_message = TGroupThread.find_by(id: params[:id])
      end
    end
  
  
    def update
       #check unlogin user
       checkuser
  
       @m_channel = MChannel.find_by(id: session[:s_channel_id])
       if @m_channel.nil?
        redirect_to home_url
       else
          @group_thread_message = TGroupThread.new(messagethread_params)
  
        if  @group_thread_message.groupthreadmsg == "" ||  @group_thread_message.groupthreadmsg.nil?
          flash[:danger] = "Channel Message can't be blank."
          redirect_to chmsgthreadedit_url(id: @group_thread_message.id)
        else 
          TGroupThread.where(id: @group_thread_message.id).update_all(groupthreadmsg: @group_thread_message.groupthreadmsg)
          @t_group_message = TGroupMessage.find_by(id:  @group_thread_message.t_group_message_id)
          
          redirect_to @t_group_message
        end
       end
    end 
  
    private
      def messagethread_params
        params.require(:t_group_thread).permit(:id, :groupthreadmsg, :t_group_message_id,:m_user_id)
      end
      
  
      def redirect_cancel
        redirect_to my_page_path if params[:cancel]
      end
  end
   #20190916 Create by Myo Min Naing@CyberMissions Myanmar Company limited
  