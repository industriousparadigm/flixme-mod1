
class CLI

    def initialize
      @prompt = TTY::Prompt.new
    end

    def logo
      logo = Artii::Base.new :font => 'slant'
      puts logo.asciify("F L I X-M E")
    end

    def get_users_name
      name = @prompt.ask("What's your username?")
      @user = User.find_or_create_by(name: name)
    end

    def welcome
      puts "Welcome #{@user.name}!"
    end


    def show_menu
    choice = " "
    while choice
    choice = @prompt.select("What would you like to do?", ["Access my FriendList", "Broswe my Reviews", "Exit Flix-Me"])
      case choice
        when "Exit Flix-Me"
        break
      when "Access my FriendList"
         friend_list_operations
        when "Broswe my Reviews"
          puts @user.reviews.map{|i| [Movie.find(i.movie_id).title, i.rating, i.comments]}
      end
    end
   end


    def friend_list_operations
      choice = @prompt.select("Select one of the following:", ["Show my FriendList", "Browse FriendList", "Add new Friend"])
        if choice == "Add new Friend"
            target_friend = @prompt.ask("Who would you like to add")
            @user.add_friend_by_name(target_friend)
            show_menu_options
          elsif choice == "Show my FriendList"
              show_their_friends
              show_menu_options
            end
      end

    def show_menu_options
      choice = @prompt.select("",["Continue to access my FriendList.", "Go back to main_menu."])
      if choice == "Go back to main_menu."
        show_menu
      elsif choice == "Continue to access my FriendList."
        friend_list_operations
      end
    end

    def show_their_friends
      puts "Heres your friend list:"
      puts @user.friends.map(&:name)
    end

    def target_friend
    end

    def start
      logo
      get_users_name
      welcome
      show_menu
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
