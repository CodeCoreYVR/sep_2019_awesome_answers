class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question, only: [ :create ]
  before_action :authorize_user!, only: [ :create ]

  def create
    like = Like.new(question: @question, user: current_user)
    if like.save
      flash[:success] = "Question liked"
    else
      flash[:danger] = like.errors.full_messages.join(", ")
    end
    redirect_to question_path(@question)
  end

  def destroy
    like = current_user.likes.find params[:id]
    if can? :destroy, like
      like.destroy
      flash[:success] = "Question unliked"
    else
      flash[:alert] = "Can't delete like"
    end
    redirect_to question_path(like.question)
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def authorize_user!
    unless can? :like, @question
      flash[:danger] = "Don't be a narcissist"
      redirect_to question_path(@question)
    end
  end
end
