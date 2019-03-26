
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
      puts ""
      puts "Welcome #{@user.name}!"
        `say "Welcome to flix me! #{@user.name}"`
    end


    def show_menu
      puts ""
      choice = " "
      while choice
      choice = @prompt.select("What would you like to do?", ["FriendList", "Reviews", "Fun Facts", "Exit Flix-Me"])
        case choice
          when "Exit Flix-Me"
            `say "Thank you for using Flix me"`
            return
          when "FriendList"
            friend_list_operations
          when "Reviews"
            reviews_operations
          when "Fun Facts"
            fun_facts
        end
      end
    end

    def friend_list_operations
        puts ""
      choice = @prompt.select("Select one of the following:", ["Show my FriendList", "Add new Friend", "Delete Friend"])
        if choice == "Add new Friend"
            temp_target_friend = @prompt.ask("Who would you like to add").strip
            if temp_target_friend == @user.name
            puts "User trying to add himself as friend, FOREVER ALONE DETECTED, COMMENCING SHUTDOWN"
            elsif User.all.map(&:name).include?(temp_target_friend.to_s)
            @user.add_friend_by_name(temp_target_friend)
            puts "#{@user.name} and #{temp_target_friend} are now friends!"
          else
            puts "User not found, return to FriendList menu"
              friend_list_operations
            end
          elsif choice == "Show my FriendList"
              show_their_friends
              show_menu_options_friend
            elsif choice == "Delete Friend"
              temp_target_friend = @prompt.ask("Who you want to delete from your Friendlist?").strip
              check = @user.friends.map(&:name).include?(temp_target_friend.to_s)
              if check
                @user.delete_friend_by_name(temp_target_friend)
                puts ""
                puts "You and #{temp_target_friend} are no longer friends..."
              else
                puts ""
                puts "You and #{temp_target_friend} are not friend. AT ALL"
            end
      end
    end

      def reviews_operations
        puts ""
        choice = @prompt.select("Select one of the following:", ["Browse my reviews", "Add new Review", "Return to main menu", "Delete an existing review", "Update an existing review"])
        if choice == "Add new Review"
          temp_target_movie = @prompt.ask("What movie would you like to review?").strip
            if Movie.all.map(&:title).include?(temp_target_movie)
                  target_movie = temp_target_movie
                else
                    puts "Movie not found, returning to Reviews Option Menu" && return
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
                user_reviews = @user.reviews.map{|i| ["",Movie.find(i.movie_id).title, "You have rated it:#{i.rating}", i.comments]}
                if user_reviews.size > 0
                  puts user_reviews
                  else
                    puts "You have not reviewed anything. Get your opinion out there!" && return
                  end
        elsif choice == "Delete an existing review"
          user_reviews = @user.reviews.map{|i| ["",Movie.find(i.movie_id).title, "You have rated it:#{i.rating}", i.comments]}
          if user_reviews.size > 0
          movie_name = @prompt.select("Select one of the following:", @user.reviews.map{ |i| i.movie.title })
            @user.delete_review(movie_name)
            @user = User.find_or_create_by(name: @user.name)
          puts "You deleted the review of #{movie_name}"
        else
          puts "No review to delete"
        end

    elsif choice == "Update an existing review"
          user_reviews = @user.reviews.map{|i| ["",Movie.find(i.movie_id).title, "You have rated it:#{i.rating}", i.comments]}

          if user_reviews.size > 0
          movie_name = @prompt.select("Select one of the following:", @user.reviews.map{ |i| i.movie.title })
          new_review = @prompt.ask("Type a new review for the movie: #{movie_name}")
          new_rating = @prompt.ask('Leave a new rating (1-5) ') do |i|
            i.in '1-5'
            i.messages[:range?] = '%{value} out of expected range #{in}'
          end
            @user.update_review(movie_name, new_rating, new_review)
            @user = User.find_or_create_by(name: @user.name)
          puts "You successfully update the review of #{movie_name}"
        else
          puts "No review to update"
        end

        elsif choice == "Return to main menu"
           return
        end
      end

    def show_menu_options_review
            puts ""
      choice = @prompt.select("Select one of the following:",["Continue to access my Reviews.", "Go back to main_menu."])
      if choice == "Go back to main_menu."
        return
      elsif choice == "Continue to access my Reviews."
        reviews_operations
      end
    end

    def show_menu_options_friend
            puts ""
      choice = @prompt.select("",["Continue to access my FriendList.", "Go back to main_menu."])
      if choice == "Go back to main_menu."
        return
      elsif choice == "Continue to access my FriendList."
        friend_list_operations
      end
    end

    def show_their_friends
            puts ""
      puts "Heres your friend list:"
      puts @user.friends.map(&:name)
    end

    def start
      logo
      get_users_name
      welcome
      show_menu
    end

    def fun_facts
            puts ""
      choice = @prompt.select("Select one of the following:", ["Find the top 5 movies", "Most reviewed movie", "Most active reviewer", "Back to main menu"])
      if choice == "Most reviewed movie"
      puts Movie.most_reviewed_movie.title
        fun_facts
      elsif choice == "Find the top 5 movies"
        puts Movie.top_5_movies
        fun_facts
      elsif choice == "Most active reviewer"
      puts User.most_active_reviewer
        fun_facts
      elsif choice == "Back to main menu"
        return
      end
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
