# -*- encoding : utf-8 -*-
Cobra::Application.routes.draw do

  devise_for :users
  resources :users

  resource :user

  post "become" => "admin#become"
  post "students/api" => "students#api"

  resources :events do
    member do
      get :sale
      get :multi_sale
      get :handout
      get :statistics
      post :add_user
      post :remove_user
    end

    resources :students do
      post :search, :on => :collection
      post :multi_search, :on => :collection
      post :search_card, :on => :collection
    end

    get :new_union_list
    post :create_union_list

    resources :registration_batches do
      member do
        post :generate_tickets
        get :data
      end
      resources :visitors do
        post :search, :on => :collection
        post :reload_from_liu
      end
    end

    resources :visitors do
      post :search, :on => :collection
    end

    resources :ticket_types
    resources :tickets do
      post :sale, :on => :collection
      member do
        put :handout
      end
    end
  end

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get :short
  #       post :toggle
  #     end
  #
  #     collection do
  #       get :sold
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get :recent, :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => "events#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
