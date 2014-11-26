Addressbook::Engine.routes.draw do
  root to: "contacts#index"
  resources :contacts, except: [:show] do
    collection do
      post :import_vcard
      post :import_csv
    end
  end
  resources :groups, except: [:show]
end
