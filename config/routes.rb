SampleApp::Application.routes.draw do
  get "static_pages/home"

  get "static_pages/help"

  # root :to => "controller#action", as "/"
end
