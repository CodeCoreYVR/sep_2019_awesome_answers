require 'rails_helper'

RSpec.describe JobPostsController, type: :controller do

  def current_user
    @current_user ||= FactoryBot.create(:user)
  end

  def unauthorized_user
    @unauthorized_user ||= FactoryBot.create(:user)
  end

  describe '#new' do
    context "without signed in user" do
      it "redirects the user to session new" do

        get(:new)

        expect(response).to redirect_to(new_session_path)
      end

      it "sets a danger flash message" do
        get(:new)

        expect(flash[:danger]).to be
      end
    end
    context "with signed in user" do
      before do
        # To simulate signing in a user, set a `user_id` in the
        # `session`. RSpec makes controller's session available
        # inside your tests.
        session[:user_id] = current_user.id
      end

      it 'renders the new template' do
        # GIVEN
        # Defaults

        # WHEN
        # Making a GET request to the new action
        get(:new)
        # THEN
        # The `response` object contains the rendered template `new`
        # The respinse object is available inside any controller. It
        # is similar to `response` available in Express Middleware,
        # however we rarely interact with it in Rails. Rspec makes
        # it available when testing, in order to verify its contents.

        # Here we verify with the `render_template` matcher that it
        # contains the right rendered template.
        expect(response).to(render_template(:new))
      end

      it 'sets an instance variable with a new job post' do
        get(:new)
        # assigns(:job_post) - returns the value of an instance
        # variable @job_post from the instance of our
        # JobPostsController.
        # Only available if the gem 'rails-controller-testing' is
        # added.
        expect(assigns(:job_post)).to(be_a_new(JobPost))
        # The above matcher (be_a_new) will verify that the expected
        # value is a new instance of the JobPost model
      end
    end
  end

  describe '#create' do
    def valid_request
      # The post method below simulates an HTTP request to the
      # create action of JobPostsController using the POST verb
      # This has the effect of a user filling out our new form
      # in a browser and submitting.
      post(:create, params: { job_post: FactoryBot.attributes_for(:job_post) })
    end

    context "without signed in user" do
      it "redirects to the new session" do
        valid_request
        expect(response).to redirect_to(new_session_path)
      end
      # Could do our flash message test here also again.
    end
    context "with signed in user" do
      before do
        session[:user_id] = current_user.id
      end
      # `context` is functionally the same as `describe`, but
      # we use context to group branching code paths.
      context 'with valid parameters' do

        it 'creates a job post in the db' do
          count_before = JobPost.count
          valid_request
          count_after = JobPost.count
          expect(count_after).to(eq(count_before + 1))
        end

        it 'redirects us to the show page for that job post' do
          valid_request
          job_post = JobPost.last
          expect(response).to(redirect_to(job_post_url(job_post.id)))
        end

        it "associates the current user to the created job post" do
          valid_request

          job_post = JobPost.last
          expect(job_post.user).to eq(current_user)
        end
      end
      context 'with invalid parameters' do
        def invalid_request
          post(:create, params: { job_post: FactoryBot.attributes_for(:job_post, title: nil) })
        end

        it 'doesnt save a job post in the db' do
          count_before = JobPost.count
          invalid_request
          count_after = JobPost.count
          expect(count_after).to eq(count_before)
        end

        it 'renders the new template' do
            invalid_request
            expect(response).to render_template(:new)
        end

        it 'assigns an invalid job_post as an instance variable' do
            invalid_request
            expect(assigns(:job_post)).to be_a(JobPost)
            expect(assigns(:job_post).valid?).to be(false)
        end
      end
    end
  end

  describe '#show' do
    it 'renders the show template' do
      job_post = FactoryBot.create(:job_post)
      get(:show, params: { id: job_post.id })
      expect(response).to render_template(:show)
    end

    it 'sets an instance variable @job_post for the shown object' do
      job_post = FactoryBot.create(:job_post)
      get(:show, params: { id: job_post.id })
      expect(assigns(:job_post)).to eq(job_post)
    end
  end

  describe '#destroy' do
    context "without signed in user" do
      it "redirects to new session" do
        job_post = FactoryBot.create(:job_post)

        delete(:destroy, params: { id: job_post.id })

        expect(response).to redirect_to(new_session_path)
      end
    end
    context "with signed in user" do
      before do
        session[:user_id] = current_user.id
      end

      context "as non-owner" do
        before do
          @job_post = FactoryBot.create(:job_post)
          delete(:destroy, params: { id: @job_post.id })
        end

        it "doesn't remove the job post" do
          expect(JobPost.find_by(id: @job_post.id)).to(eq(@job_post))
        end

        it "redirects to the job post show" do
          delete(:destroy, params: { id: @job_post.id })

          expect(response).to redirect_to(job_post_url(@job_post.id))
        end

        it "flashes a danger message" do
          delete(:destroy, params: { id: @job_post.id })

          expect(flash[:danger]).to be
        end
      end
      context "as owner" do
        before do
          @job_post = FactoryBot.create(:job_post, user: current_user)
          delete(:destroy, params: { id: @job_post.id })
        end
        it 'removes a job post from the db' do
          expect(JobPost.find_by(id: @job_post.id)).to be(nil)
        end

        it 'redirects to the job post index' do
          expect(response).to redirect_to(job_posts_url)
        end

        it 'sets a flash message' do
          expect(flash[:danger]).to be
        end
      end
    end
  end

  describe '#index' do
    it 'renders the index template' do
      get :index
      expect(response).to render_template(:index)
    end
    it 'assigns an instance variable @job_posts to all created job posts' do
      job_post_1 = FactoryBot.create(:job_post)
      job_post_2 = FactoryBot.create(:job_post)
      get :index
      expect(assigns(:job_posts)).to eq([job_post_2, job_post_1])
    end

  end

  describe "#edit" do
    before do
      @job_post = FactoryBot.create(:job_post, user: current_user)
    end

    context "with no user signed in" do
      it "redirects to the sign in page" do
        get :edit, params: { id: @job_post.id }
        expect(response).to redirect_to new_session_path
      end
    end

    context "with user signed in" do
      context "with authorized user" do
        before do
          session[:user_id] = current_user.id
          get :edit, params: { id: @job_post.id }
        end

        it "renders the edit template" do
          get :edit, params: { id: @job_post.id }
          expect(response).to render_template :edit
        end

        it "sets an instance variable based on the post id that is passed" do
          get :edit, params: { id: @job_post.id }
          expect(assigns(:job_post)).to eq(@job_post)
        end
      end

      context "with unauthorized user" do

        before do
          session[:user_id] = unauthorized_user.id
          get :edit, params: { id: @job_post.id }
        end

        it "redirects to the root path" do
          expect(response).to redirect_to root_path
        end

        it "sets a flash message" do
          expect(flash[:alert]).to be
        end
      end
    end
  end

  describe "#update" do
    before do
      @job_post = FactoryBot.create(:job_post, user: current_user)
    end

    context "with user signed in" do
      context "with authorized user" do
        before do
          session[:user_id] = current_user.id
        end
        context 'with valid parameters' do

          it "updates the job post record with new attributes" do
            new_title = "#{@job_post.title} Plus Changes!"
            patch :update, params: {id: @job_post.id, job_post: {title: new_title}}
            expect(@job_post.reload.title).to eq(new_title)
          end

          it "redirect to the job post show page" do
            new_title = "#{@job_post.title} plus changes!"
            patch :update, params: {id: @job_post.id, job_post: {title: new_title}}
            expect(response).to redirect_to(@job_post)
          end
        end

        context 'with invalid parameters' do
          def invalid_request
            patch :update, params: {id: @job_post.id, job_post: {title: nil}}
          end

          it "doesn't update the job post with new attributes" do
            expect { invalid_request }.not_to change { @job_post.reload.title }
          end

          it "renders the edit template" do
            invalid_request
            expect(response).to render_template(:edit)
          end
        end
      end

      context "with unauthorized user" do
        before do
          session[:user_id] = unauthorized_user.id
          patch :update, params: {id: @job_post.id, job_post: {title: "New title that shouldn't be updated anyways"}}
        end

        it "redirects to the root path" do
          expect(response).to redirect_to root_path
        end

        it "sets a flash message" do
          expect(flash[:alert]).to be
        end
      end
    end
  end

end
