Rails.application.routes.draw do
  get 'questions/new'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # This defines a `route` rule that says when
   # we receive a `GET` request with URL `/`
   # handle it using the WelcomeController, with
   # the index action inside that controller.
   # The `as` option is used for the helper url/
   # path, it overrides or generates helper
   # methods that you can use in your views or
   # controllers
  get('/', {to: 'welcome#index', as: :root})
  get '/contacts/new', {to: 'contacts#new'}
  post '/contacts', {to: 'contacts#create' }

 # question new page
  # when someone requests /questions/new it will be handled by the NEW method
  # inside of questions controller 
  # get '/questions/new', {to: 'questions#new', as: :new_question}
  # get '/questions/:id', {to: 'questions#show', as: :question }

  # handles submission of new questions form
  # post 'questions', {to: 'questions#create', as: :questions}

  # question show page
  # adding the alias `as: :question` will create the helper paths/url to question_path
  # we can use these like so: question_path(<id>), question_url(<id>)
  # get '/questions/:id', {to: 'questions#show', as: :question}

  # question index page
  # get '/questions', {to: 'questions#index'}

  # question edit page
  # get '/questions/:id/edit', {to: 'questions#edit', as: :edit_question}

  # handles submission of form on the question edit page
  # patch '/questions/:id', {to: 'questions#update'}

  # delete '/questions/:id', {to: 'questions#destroy'}

  # this builds all of the above routes for us ;)
   resources :questions
end
