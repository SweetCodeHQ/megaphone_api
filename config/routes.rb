Rails.application.routes.draw do
  post "/graphql", to: "graphql#execute"
  post "/topic_alert_emails", to: "topic_alert_emails#create"
  post "/signup_alert_emails", to: "signup_alert_emails#create"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  if Rails.env.test?
    mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "graphql#execute"
  end
end
