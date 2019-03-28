require_relative './config/environment'
require 'sinatra/activerecord/rake'

    desc 'Start our app console'
    task :console do
    Pry.start
    end

    desc "Start the app"
    task :run do
      system(export SINATRA_ACTIVESUPPORT_WARNING=false)

      cli = CLI.new
      cli.start
    end
