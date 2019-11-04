Rails.application.routes.draw do

  root 'static_pages#welcome'
  get 'welcome' => 'static_pages#welcome'

  get'workspace' => 'm_workspaces#new'

  get 'signin' =>  'sessions#new'
  post 'signin' =>  'sessions#create'

  get 'change_password' => 'change_password#new'

  get 'home' =>  'static_pages#home'

  get 'memberinvite' => 'member_invitation#new'
  post 'memberinvite' => 'member_invitation#invite'
  get 'confirminvitation' => 'm_users#confirm'

  get 'channelcreate' => 'm_channels#new'
  post 'channelcreate' => 'm_channels#create'
  
  get 'channeledit' => 'm_channels#edit'
  get 'delete_channel' => 'm_channels#delete'
  post 'channelupdate'=> 'm_channels#update'

  get 'star' => 't_direct_star_msg#create'
  get 'unstar' => 't_direct_star_msg#destroy'
  get 'starthread' => 't_direct_star_thread#create'
  get 'unstarthread' => 't_direct_star_thread#destroy'

  get 'delete_directmsg' => "direct_message#deletemsg"
  get 'delete_directthread' => "direct_message#deletethread"

  get 'delete_groupmsg' => "group_message#deletemsg"
  get 'delete_groupthread' => "group_message#deletethread"

  get 'groupstar' => 't_group_star_msg#create'
  get 'groupunstar' => 't_group_star_msg#destroy'
  get 'groupstarthread' => 't_group_star_thread#create'
  get 'groupunstarthread' => 't_group_star_thread#destroy'

  get 'starlists' => 'star_lists#show'
  get 'thread' => 'thread#show'
  get 'mentionlists' => 'mention_lists#show'
  get 'allunread' => 'all_unread#show'

  get 'usermanage' => 'user_manage#usermanage'
  get 'edit' => 'user_manage#edit'
  get 'update' => 'user_manage#update'

  get 'channeluser' => 'channel_user#show'
  get 'channeluseradd' => 'channel_user#create'
  get 'channeluserdestroy' => 'channel_user#destroy'
  get 'channeluserjoin' => 'channel_user#join'

  post 'directmsg' => 'direct_message#show'
  post 'directthreadmsg' => 'direct_message#showthread'
  
  post 'groupmsg' => 'group_message#show'
  post 'groupthreadmsg' => 'group_message#showthread'

  get 'refresh' => 'sessions#refresh'
  get 'updatedirectmsg' => 'sessions#updatedirectmsg'
  get 'updategroupmsg' => 'sessions#updategroupmsg'

  get 'refresh_direct' => 'm_users#refresh_direct'
  get 'refresh_group' => 'm_channels#refresh_group'
  delete 'logout' =>  'sessions#destroy'
  
  #20190916 Create by Myo Min Naing@CyberMissions Myanmar Company limited
  get 'channelmsgedit' => "t_group_messages#edit"
  post 'channelmsgupdate' => "t_group_messages#update"

  get 'chmsgthreadedit' => "t_group_threads#edit"
  post 'chmsgthreadupdate' => "t_group_threads#update"
  
  get 'directmsgedit' => "t_direct_messages#edit"
  post 'directmsgupdate' => "t_direct_messages#update"

  get 'directthreadedit' => "t_direct_threads#edit"
  post 'directthreadupdate' => "t_direct_threads#update"
  #20190916 Create by Myo Min Naing@CyberMissions Myanmar Company limited

  #Thu Zin Tun 27082019
  get 'change_workspacename' => 'm_workspaces#changeworkspacename'
  post 'change_workspacename' => 'm_workspaces#change'
  get 'logout' =>  'sessions#destroy'
  get 'delete_workspace' =>  'm_workspaces#delete'
  get 'forgot_password' => 'forgot#new'
  post 'forgot_password' => 'forgot#password_reset'
  #get 'password_reset' => 'forgot#edit'
  post 'password_reset' => 'forgot#edit'
  get 'reset_password' => 'forgot#resetPassword'
  #Thu Zin Tun 27082019
  
  #Profile by Yin Yin Aye@CyberMissions Myanmar Company limited
  get 'myprofile' => 'm_users#myprofile'
  get 'viewprofile' => 'm_users#viewprofile'
  get 'editprofile' => 'm_users#editprofile'
  post 'save' => 'm_users#save'
  #Profile Create by Yin Yin Aye@CyberMissions Myanmar Company limited
  
  resources :m_workspaces
  resources :m_users
  resources :m_channels
  resources :t_direct_messages
  resources :t_direct_threads
  resources :t_group_threads
  resources :t_group_messages
  #Profile by Yin Yin Aye@CyberMissions Myanmar Company limited
  resources :userprofile
  #Profile Create by Yin Yin Aye@CyberMissions Myanmar Company limited
  

end
