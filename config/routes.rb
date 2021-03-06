# == Route Map
#
#                           Prefix Verb   URI Pattern                                                                              Controller#Action
#                letter_opener_web        /letter_opener                                                                           LetterOpenerWeb::Engine
#                      sidekiq_web        /sidekiq                                                                                 Sidekiq::Web
#                 new_user_session GET    /users/sign_in(.:format)                                                                 users/sessions#new
#                     user_session POST   /users/sign_in(.:format)                                                                 users/sessions#create
#             destroy_user_session DELETE /users/sign_out(.:format)                                                                users/sessions#destroy
#                new_user_password GET    /users/password/new(.:format)                                                            devise/passwords#new
#               edit_user_password GET    /users/password/edit(.:format)                                                           devise/passwords#edit
#                    user_password PATCH  /users/password(.:format)                                                                devise/passwords#update
#                                  PUT    /users/password(.:format)                                                                devise/passwords#update
#                                  POST   /users/password(.:format)                                                                devise/passwords#create
#         cancel_user_registration GET    /users/cancel(.:format)                                                                  devise/registrations#cancel
#            new_user_registration GET    /users/sign_up(.:format)                                                                 devise/registrations#new
#           edit_user_registration GET    /users/edit(.:format)                                                                    devise/registrations#edit
#                user_registration PATCH  /users(.:format)                                                                         devise/registrations#update
#                                  PUT    /users(.:format)                                                                         devise/registrations#update
#                                  DELETE /users(.:format)                                                                         devise/registrations#destroy
#                                  POST   /users(.:format)                                                                         devise/registrations#create
#                           signup GET    /signup(.:format)                                                                        devise/registrations#new
#                            login GET    /login(.:format)                                                                         users/sessions#new
#                           logout DELETE /logout(.:format)                                                                        users/sessions#destroy
#                             root GET    /                                                                                        posts#index
#                            users GET    /users(.:format)                                                                         users#index
#                             user GET    /users/:id(.:format)                                                                     users#show
#                    post_comments POST   /posts/:post_id/comments(.:format)                                                       comments#create
#                edit_post_comment GET    /posts/:post_id/comments/:id/edit(.:format)                                              comments#edit
#                     post_comment PATCH  /posts/:post_id/comments/:id(.:format)                                                   comments#update
#                                  PUT    /posts/:post_id/comments/:id(.:format)                                                   comments#update
#                                  DELETE /posts/:post_id/comments/:id(.:format)                                                   comments#destroy
#                     search_posts GET    /posts/search(.:format)                                                                  posts#search
#                            posts GET    /posts(.:format)                                                                         posts#index
#                                  POST   /posts(.:format)                                                                         posts#create
#                         new_post GET    /posts/new(.:format)                                                                     posts#new
#                        edit_post GET    /posts/:id/edit(.:format)                                                                posts#edit
#                             post GET    /posts/:id(.:format)                                                                     posts#show
#                                  PATCH  /posts/:id(.:format)                                                                     posts#update
#                                  PUT    /posts/:id(.:format)                                                                     posts#update
#                                  DELETE /posts/:id(.:format)                                                                     posts#destroy
#                            likes POST   /likes(.:format)                                                                         likes#create
#                             like DELETE /likes/:id(.:format)                                                                     likes#destroy
#                    relationships POST   /relationships(.:format)                                                                 relationships#create
#                     relationship DELETE /relationships/:id(.:format)                                                             relationships#destroy
#                    read_activity PATCH  /activities/:id/read(.:format)                                                           activities#read
#              edit_mypage_account GET    /mypage/account/edit(.:format)                                                           mypage/accounts#edit
#                   mypage_account PATCH  /mypage/account(.:format)                                                                mypage/accounts#update
#                                  PUT    /mypage/account(.:format)                                                                mypage/accounts#update
#                mypage_activities GET    /mypage/activities(.:format)                                                             mypage/activities#index
# edit_mypage_notification_setting GET    /mypage/notification_setting/edit(.:format)                                              mypage/notification_settings#edit
#      mypage_notification_setting PATCH  /mypage/notification_setting(.:format)                                                   mypage/notification_settings#update
#                                  PUT    /mypage/notification_setting(.:format)                                                   mypage/notification_settings#update
#                chatroom_messages GET    /chatrooms/:chatroom_id/messages(.:format)                                               messages#index
#                                  POST   /chatrooms/:chatroom_id/messages(.:format)                                               messages#create
#             new_chatroom_message GET    /chatrooms/:chatroom_id/messages/new(.:format)                                           messages#new
#                     edit_message GET    /messages/:id/edit(.:format)                                                             messages#edit
#                          message GET    /messages/:id(.:format)                                                                  messages#show
#                                  PATCH  /messages/:id(.:format)                                                                  messages#update
#                                  PUT    /messages/:id(.:format)                                                                  messages#update
#                                  DELETE /messages/:id(.:format)                                                                  messages#destroy
#                        chatrooms GET    /chatrooms(.:format)                                                                     chatrooms#index
#                                  POST   /chatrooms(.:format)                                                                     chatrooms#create
#                         chatroom GET    /chatrooms/:id(.:format)                                                                 chatrooms#show
#               rails_service_blob GET    /rails/active_storage/blobs/:signed_id/*filename(.:format)                               active_storage/blobs#show
#        rails_blob_representation GET    /rails/active_storage/representations/:signed_blob_id/:variation_key/*filename(.:format) active_storage/representations#show
#               rails_disk_service GET    /rails/active_storage/disk/:encoded_key/*filename(.:format)                              active_storage/disk#show
#        update_rails_disk_service PUT    /rails/active_storage/disk/:encoded_token(.:format)                                      active_storage/disk#update
#             rails_direct_uploads POST   /rails/active_storage/direct_uploads(.:format)                                           active_storage/direct_uploads#create
#
# Routes for LetterOpenerWeb::Engine:
# clear_letters DELETE /clear(.:format)                 letter_opener_web/letters#clear
# delete_letter DELETE /:id(.:format)                   letter_opener_web/letters#destroy
#       letters GET    /                                letter_opener_web/letters#index
#        letter GET    /:id(/:style)(.:format)          letter_opener_web/letters#show
#               GET    /:id/attachments/:file(.:format) letter_opener_web/letters#attachment

require 'sidekiq/web'

Rails.application.routes.draw do
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: '/letter_opener'
    mount Sidekiq::Web, at: '/sidekiq'
  end

  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }

  devise_scope :user do
    get 'signup', to: 'devise/registrations#new'
    get 'login', to: 'users/sessions#new'
    delete 'logout', to: 'users/sessions#destroy'
  end

  root 'posts#index'

  resources :users, only: [:index, :show]
  resources :posts do
    resources :comments, only: [:create, :edit, :update, :destroy]

    collection do
      get :search
    end
  end
  resources :likes, only: [:create, :destroy]
  resources :relationships, only: [:create, :destroy]
  resources :activities, only: [] do
    patch :read, on: :member
  end

  namespace :mypage do
    resource :account, only: [:edit, :update]
    resources :activities, only: [:index]
    resource :notification_setting, only: [:edit, :update]
  end

  resources :chatrooms, only: [:index, :create, :show], shallow: true do
    resources :messages
  end
end
