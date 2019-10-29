ActionMailer::Base.smtp_settings ={
    address: "smtp.gmail.com",
    port: "587",
    enable_starttls_auto: true,
    authentication: :plain,
    user_name: ENV["EMAIL_USERNAME"],
    password: ENV["EMAIL_PASSWORD"]
}

# smtp stands for Simple Mail Transfer Protocol - a communication protocol for sending messages on the internet.

# usually associated with others, such as POP3 or IMAP, but SMTP is used for delivering messages, and POP3 and IMAP are used for receiving them