require 'TTY'

class CLI

  def username(sample)
    username_temp = User.find_by name: sample.to_s
    if username_temp
      @user = username_temp
      puts "Username found, welcome back #{username_temp.name}!"
    else
      new = User.create(name: sample)
      puts "Welcome #{new.name}!"
  end
end

	def welcome
    puts "THIS IS FLIXME!!!!"
	end

  def show_menu
    prompt = TTY::Prompt.new
  choice = prompt.select("What would you like to do", ["Broswe Most Viewed Movies?", "Browse FriendList", "Add new Friend"])
  if choice == "Add new Friend"
    #addfriend
  elsif choice == "Broswe Most Viewed Movies?"
    #show most viewed movies
  elsif choice == "Browse FriendList"
    @user.friendships
  end
end

	def start
	welcome
  prompt = TTY::Prompt.new
  get_username = prompt.ask("What's your username?")
  username(get_username.to_s)
  show_menu
	end
end
