class JobPostsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :destroy, :edit, :update]
  before_action :find_job_post, only: [:show, :edit, :update, :destroy]
  before_action :authorize!, only: [:edit, :update]

  def new
    @job_post = JobPost.new
  end

  def create
    @job_post = JobPost.new job_post_params
    @job_post.user = current_user
    if @job_post.save
      redirect_to job_post_path(@job_post)
    else
      render :new
    end
  end

  def show
  end

  def index
    @job_posts = JobPost.order(created_at: :desc)
  end

  def edit
  end

  def update
    if @job_post.update job_post_params
      flash[:notice] = 'Post updated!'
      redirect_to @job_post
    else
      flash[:alert] = 'Something went wrong, see errors below.'
      render :edit
    end
  end

  def destroy
    if can?(:destroy, @job_post)
      @job_post.destroy
      flash[:danger] = "Job Post deleted!"
      redirect_to job_posts_path
    else
      flash[:danger] = "Access Denied"
      redirect_to job_post_url(@job_post.id)
    end
  end

  private

  def job_post_params
    params.require(:job_post).permit(:title, :description, :min_salary, :max_salary, :company_name)
  end

  def find_job_post
    @job_post = JobPost.find params[:id]
  end

  def authorize!
    redirect_to root_path, alert: "access denied" unless can? :crud, @job_post
  end

end
