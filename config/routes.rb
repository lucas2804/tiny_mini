Rails.application.routes.draw do

  root to: 'data_imports#index'

  resources :contacts do
    collection do
      get :new_import_draw
      post :do_import_draw
    end
  end


  resources :data_imports, only: [:index] do
    collection do
      post :save
    end

    member do
      post :import_contact_csv
    end
  end

end
