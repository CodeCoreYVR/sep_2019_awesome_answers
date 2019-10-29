class AnswerMailer < ApplicationMailer

    default from: 'notifications@example.com'
    #to generate a mailer, use the following syntax
    #railsl g mailer <name-of-your-mailer>

    #In a Mailer class, the public methods are used to create and send mail. They're very similar to actions in a controller

    #to read more about mailers: https://guides.rubyonrails.org/action_mailer_basics.html
    #to send this email, do the following in your answers controller:
    #AnswerMailer.hello_world.deliver_now

    def hello_world
        HelloWorld.set(wait: 10.minutes).perform_later
        mail(
            to: "kahlil.ashanti@gmail.com",
            from: "info@awesome-answer.io",
            cc: "jj@somebody.com",
            subject: "Hello World"

        )  
    end

    #mailer method vs controller action  
    #in a Mailer class, the public methods are used to create and send mail.  They're similar to actions in a controller

    def new_answer(answer)
        #any instance variable set in a mailer will 
        #be available in its rendered templates 
        @answer = answer
        @question = answer.question 
        @question_owner = @question.user 

        mail(
            to: @question_owner.email,
            subject: "#{answer.user.first_name} answered your question!"
        )
    end
     
end

    #inline styling
    # many webmail clients block links to external stylesheets.
    # Embedded styles are becoming increasingly popular due to the rise of mobile and associated popularity of responsive design techniques, but they have their limitations. Since embedded styles are placed in the <head> of HTML documents, and some email clients like GMAIL strip out most of the styles, the result can be a hot mess jambalaya for inboxes. 
