Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "pages#pop_culture"

  # Browsers request /favicon.ico by default; point them at the existing icon.
  get "favicon.ico", to: redirect("/icon.png")

  get "life-in-the-wild", to: "pages#life_in_the_wild", as: :life_in_the_wild
  # Links straight to one tab of the Life in the Wild page
  direct(:where_they_live) { { controller: "pages", action: "life_in_the_wild", anchor: "where-they-live" } }
  direct(:what_they_do) { { controller: "pages", action: "life_in_the_wild", anchor: "what-they-do" } }
  # Old pages, now tabs of Life in the Wild
  get "habitat", to: redirect("/life-in-the-wild#where-they-live")
  get "behavior", to: redirect("/life-in-the-wild#what-they-do")
  get "classification", to: "pages#classification"
  get "body-and-food", to: "pages#body_and_food", as: :body_and_food
  # Old pages, now tabs on Bodies & Food
  get "anatomy", to: redirect("/body-and-food#body")
  get "diet", to: redirect("/body-and-food#food")
  # Famous Elephants is now the home page
  get "pop-culture", to: redirect("/")
  get "school-projects", to: "pages#school_projects", as: :school_projects

  # The Photos page is gone: its photos now sit on the pages they belong to
  get "gallery", to: redirect("/")
  get "gallery/:slug", to: redirect { |params, _request| GalleryPhoto.page_for(params[:slug]) }
end
