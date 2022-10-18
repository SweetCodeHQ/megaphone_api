Rails.application.routes.draw do
  post "/graphql", to: "graphql#execute"
  post "/email", to: "email#create"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  if Rails.env.test?
    mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "graphql#execute"
  end
end
