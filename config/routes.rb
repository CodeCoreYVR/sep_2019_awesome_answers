Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # The option 'defaults: { format: :json }' will set `json` as the default response
  # format for all routes contained within the block of the namespace.
  # The namespace method in Rails routes makes it so it will automatically
   # look in a directory api, then in a subdirectory v1 for QuestionsController
  namespace :api, defaults: { format: :json } do
    # /api...
    namespace :v1 do
      # /api/v1...
      resources :questions
      # /api/v1/questions
      resource :session, only: [:create, :destroy]
    end
  end

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

  #routes written inside of a block passed
  #to a 'resources' method will be pre-fixed by a path
  #corresponding to the passed in symbol
  #for example here we see that all nested routes will be
  #prefixed with '/questions/:question_id'
   resources :questions do
    resources :answers, only: [:create, :destroy]
    resources :likes, shallow: true, only: [ :create, :destroy ]
    # The `shallow: true` named argument will separate routes
    # that require the parent from those that don't. Routes
    # that require the parent (i.e. index, new & create) will
    # not change
    # Roytes that don't require the parent (i.e. show, edit, update
    # destroy ) will have the parent prefix
    # (i.e. /question/:question_id/) removed

    # Use the 'on' named argument to specify how a
    # nested route behaves relative to its parent.

    # `on: :collection` means that it acts on the entire
    # resource. All questions in this case. new and create
    # act on the collection

    # `on: :member` means that it acts on a single resource.
    # A signle question in this case. edit, destroy, show and update
    # are all member routes
    get :liked, on: :collection
    resources :publishings, only: :create
   end

   resources :users, shallow: true, only: [:new, :create, :show] do
     resources :gifts, only: [:new, :create] do
       resources :payments, only: [:new, :create]
     end
   end

   resource :session, only: [:new, :create, :destroy]

   get "/auth/github", as: :sign_in_with_github
   get "/auth/:provider/callback", to: "callbacks#index"
   # get "/auth/github/callback", to: "callbacks#index"
   # get "/auth/facebook/callback", to: "callbacks#index"
   # get "/auth/twitter/callback", to: "callbacks#index"


   resources :job_posts

   #resources :sessions vs resource :session
   #resourc is singular and unlike 'resources' 'resource' will create routes that do CRUD operation on only one thing. There will be no index routes and no route will have a ':id' wild card.  When using a singular resource, the controller must still be PLURAL

   #routes for delayed job, when generating delayed job be sure to stop the Spring server in terminal by typing 'Spring stop'
   #to generate a delayed job from your terminal use rails g delayed_job:active_record
   match(
     "/delayed_job",
     to: DelayedJobWeb,
     anchor: false,
     via: [:get, :post]
   )
end
