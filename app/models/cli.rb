
class CLI

  def initialize
    @prompt = TTY::Prompt.new
  end

  def get_users_name
    name = @prompt.ask("What's your username?")
    @user = User.find_or_create_by(name: name)
  end

  def welcome
    puts "Welcome #{@user.name}!"
  end

    def show_menu
      choice = @prompt.select("What would you like to do", ["Broswe Most Viewed Movies?", "Browse FriendList", "Add new Friend"])
        if choice == "Add new Friend"
          add_friend
        elsif choice == "Broswe Most Viewed Movies?"
          #show most viewed movies
        elsif choice == "Browse FriendList"
          show_their_friends
        end
    end

  def show_their_friends
    puts "Heres your friend list"
    puts @user.friends.map(&:name)
  end

  def add_friend
    @prompt.select("Here's a list of all current users, please select who you woud like to befriend", Artist.all_names) #MAybe multiple choices?
  end

  def start
    puts "FLIXME WELCOME MAT"
    get_users_name
    welcome
    show_menu
      puts "Ok, bye!"
  end

end
# require 'TTY'
#
# class CLI
#
#   def username(sample)
#     username_temp = User.find_by name: sample.to_s
#     if username_temp
#       @user = username_temp
#       puts "Username found, welcome back #{username_temp.name}!"
#     else
#       new = User.create(name: sample)
#       puts "Welcome #{new.name}!"
#   end
# end
#
# 	def welcome
#     puts "THIS IS FLIXME!!!!"
# 	end
#
#   def show_menu
#     prompt = TTY::Prompt.new
#   choice = prompt.select("What would you like to do", ["Broswe Most Viewed Movies?", "Browse FriendList", "Add new Friend"])
#   if choice == "Add new Friend"
#     #addfriend
#   elsif choice == "Broswe Most Viewed Movies?"
#     #show most viewed movies
#   elsif choice == "Browse FriendList"
#     @user.friendships
#   end
# end
#
# 	def start
# 	welcome
#   prompt = TTY::Prompt.new
#   get_username = prompt.ask("What's your username?")
#   username(get_username.to_s)
#   show_menu
# 	end
# end
