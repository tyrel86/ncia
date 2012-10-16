Ncia::Application.routes.draw do

	get "/blogs/admin_index" => "blogs#admin_index"
  resources :blogs

  match 'signup' => 'users#new', :as => :signup
  match 'logout' => 'sessions#destroy', :as => :logout
  match 'login' => 'sessions#new', :as => :login
  resources :sessions
  resources :users
	resources :password_resets, only: [:create, :edit, :update, :new]

	get "members/admin_index" => "members#admin_index"
	get "members/portal/:id" => "members#portal_show", as: "members_portal_show"
  resources :members

  resources :staffs, except: [:index, :show]
	get "staffs/staff" => "staffs#staff_index", as: :staff_index
	get "staffs/board" => "staffs#board_index", as: :board_index
	get "staffs/admin_index" => "staffs#admin_index"

  resources :events, except: [:show]
	get "/events/admin_index" => "events#admin_index"

  resources :contact_messages, only: [:create, :destroy]
	get "contact_messages/admin_index" => "contact_messages#admin_index"

  resources :articles, except: [:show]
	get "/articles/admin_index" => "articles#admin_index"
	get "/articles/:title" => "articles#show"

  root :to => 'pages#home'

	resources :banners, :only => [:new, :create, :edit, :update, :destroy]
	get "/banners/admin_index" => "banners#admin_index", as: :banners_admin_index
	get "/banners/:id/activate" => "banners#activate", as: :activate_banner

	get  '/:title' => 'pages#show', as: "pages"
	get  'pages/:title/edit' => 'pages#edit'
	put  'pages/:title'      => 'pages#update'

end
