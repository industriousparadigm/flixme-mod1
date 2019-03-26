
class CLI

    def initialize
      @prompt = TTY::Prompt.new
    end

    def logo
      logo = Artii::Base.new :font => 'slant'
      puts logo.asciify("F L I X-M E")
      `say "Welcome to flix me"`
    end

    def get_users_name
      name = @prompt.ask("What's your username?")
      @user = User.find_or_create_by(name: name)
    end

    def welcome
      puts "Welcome #{@user.name}!"
        `say "Welcome to flix me! #{@user.name}"`
    end


    def show_menu
    choice = " "
    while choice
    choice = @prompt.select("What would you like to do?", ["Access my FriendList", "Broswe my Reviews", "Exit Flix-Me"])
      case choice
        when "Exit Flix-Me"
        `say "Thank you for using Flix me"`
        break
      when "Access my FriendList"
         friend_list_operations
        when "Broswe my Reviews"
          reviews_operations
      end
    end
   end


    def friend_list_operations
      choice = @prompt.select("Select one of the following:", ["Show my FriendList", "Add new Friend"])
        if choice == "Add new Friend"
            target_friend = @prompt.ask("Who would you like to add")
            @user.add_friend_by_name(target_friend)
            show_menu_options_friend
          elsif choice == "Show my FriendList"
              show_their_friends
              show_menu_options_friend
            end
      end

      def reviews_operations
        choice = @prompt.select("Select one of the following:", ["Browse my reviews", "Add new Review"])
        if choice == "Add new Review"
            temp_target_movie = @prompt.ask("What movie would you like to review?")
            if Movie.all.map(&:title).include?(temp_target_movie)
              target_movie = temp_target_movie
            else
              puts "Movie not found, returning to Reviews Option Menu"
              return
            end
          target_rating = @prompt.ask('How would your rate it? (1-5) ') do |i|
                i.in '1-5'
                i.messages[:range?] = '%{value} out of expected range #{in}'
              end
            target_comment = @prompt.ask("Any additional comment?")
            @user.review_movie(target_movie, target_rating, target_comment)
              puts "Rewiews submitted"
              @user = User.find_or_create_by(name: @user.name)
            show_menu_options_review
          elsif choice == "Browse my reviews"
            puts @user.reviews.map{|i| ["",Movie.find(i.movie_id).title, "You have rated it:#{i.rating}", i.comments]}
            puts ""
          end
        end

    def show_menu_options_review
      choice = @prompt.select("Select one of the following:",["Continue to access my Reviews.", "Go back to main_menu."])
      if choice == "Go back to main_menu."
        show_menu
      elsif choice == "Continue to access my Reviews."
        reviews_operations
      end
    end

    def show_menu_options_friend
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
