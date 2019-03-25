require 'TTY'

class CLI

  def username(sample)
    username_temp = User.find_by name: sample.to_s
    if username_temp
      puts "Username found, welcome back#{username_temp.name}"
    else
      new = User.create(name: sample)
      puts "Hello #{new.name}"
  end
end

	def welcome
    puts "THIS IS FLIXME!!!!"
	end

	def start
	welcome
  prompt = TTY::Prompt.new
  get_username = prompt.ask("What's your username?")
  username(get_username.to_s)
	end
end
