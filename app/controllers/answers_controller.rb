class AnswersController < ApplicationController
  before_action :authenticate_user!

    def create
      # AnswerMailer.hello_world.deliver_now
        @question = Question.find(params[:question_id])
        @answer = Answer.new answer_params
        @answer.question = @question
        @answer.user = current_user
        if @answer.save
          AnswerMailer.new_answer(@answer).deliver_now
          redirect_to question_path(@question)
        else
          # For the list of answers
          @answers = @question.answers.order(created_at: :desc)
          render 'questions/show'
        end
      end

      def destroy
        @answer = Answer.find params[:id]
        if can? :crud, @answer
          @answer.destroy
          redirect_to question_path(@answer.question)
        else
          redirect_to root_path, alert: 'Not authorized'
        end
      end

    private
    def answer_params
      params.require(:answer).permit(:body)
    end
end
