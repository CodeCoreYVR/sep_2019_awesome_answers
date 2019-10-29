class HelloWorldJob < ApplicationJob
  queue_as :default
  #to generate the migration file for "delayed_job" queue, run: rails g delayed_job:active_record

  #this file is created by using the following in your terminal: rails g job <name_of_your_job>

  def perform(*args)
    # Do something later
    puts"--------------"
    puts"Running a job"
    puts"--------------"
  end

  # to run a job, use any of the following methods:
  #<JobClass>.perform_now(<args>)
  # this will run the job synchronously (or in the foreground meandin it will not be in the queue). if it is called from Rails, Rails would execute the job instead of a worker

  #<JobClass>.perform_later(<args>)
  #this will insert the job in your queue to be executed by a worker

  #to perform jobs at a given time, use the set method:
  #<JobClass>.set(<some-kind-of-time>)

  #HelloWorld.set(wait: 10.minutes).perform_later
  #the above will insert a job in queue that will only run
  #after 10 minutes have elapsed

  #HelloWorldJob.set(run_at: 1.week.from_now).perform_later

  #to see more options and more examples/syntax - check out the ActiveJob documentation 
  #http://guides.rubyonrails.org/active_job_basics.html


  #to start a worker to run jobs from your queue, run in a separate terminal tab the following command: rails jobs:work
end
