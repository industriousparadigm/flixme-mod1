class CLI
    MAIN_MENU= ["Rate a Movie", "Get a movie recommendation", "Friends", "Reviews", "Fun Facts", "Exit Flix-Me"]
    REVIEW_OPTIONS = ["Show movie reviews", "Browse my reviews", "Add new Review", "Update an existing review", "Delete an existing review", "Return to main menu"]
    FRIENDLIST_OPTIONS = ["Show my FriendList", "Show friend reviews", "Add new Friend", "Delete Friend", "Back to main menu"]
    FUN_FACTS = ["Find the top 5 movies", "Most reviewed movie", "How many movies does this database contains?", "Most active reviewer", "Back to main menu"]
    RECOMMEND_MENU = ["Just for me", "With friends"]
    RECOMMEND_MENU_REFINED = ["Top Movies", "By Genres", "Random"]
    GENRE_MENU = []#MENUS AND SUBMENUS COSTANTS ARRAYS
  
    def initialize
      @prompt = TTY::Prompt.new
      GENRE_MENU.concat(get_genres)
    end
  
    def normalizer(string)
    string.strip.split.map{|i| i.downcase.capitalize}.join(" ")
    end
  
    def logo
      puts "                                        FLIX-ME"
      puts "                          (Not interested in cool-flashy Logos)"
      sleep(1)
    end
  
    def get_users_name
      name = ask("\nWhat's your username?")
      @user = User.find_or_create_by(name: normalizer(name))
    end
  
    def ask(question)
    @prompt.ask(question)
    end
  
    def single_select(question, options)
    @prompt.select(question, options)
    end
  
    def multi_select(question, options)
    @prompt.multi_select(question, options)
    end
  
    def welcome
      puts "\nWelcome #{@user.name}!"
    end
  
    def get_genres
     Movie.list_all_genres
    end
  
    def show_menu
        choice = single_select("\nWhat would you like to do?", MAIN_MENU)
        case choice
          when "Exit Flix-Me"
            return
          when "Friends"
            friend_list_operations
          when "Reviews"
            reviews_operations
          when "Rate a Movie"
            add_new_review
          when "Get a movie recommendation"
            recommend_a_movie
          when "Fun Facts"
            fun_facts
        end
    end
  
    def recommend_a_movie
      choice = single_select("\nWho's watching?", RECOMMEND_MENU)
      case choice
        when "Just for me"
          multilple_recomendation
        when "With friends"
          friends_names = multi_select("\nSelect one or more of your friends:",  @user.get_friends_names)
          multilple_recomendation(friends_names)
      end
    end
  
    def multilple_recomendation(friends = [])
      type_choice = single_select("\nSelect one of the following criteria:", RECOMMEND_MENU_REFINED)
      if friends.size > 0 #with friend
        case type_choice
          when "Top Movies"
            puts  @user.get_top_rated_recommendations(friends)
          when "By Genres"
            genre = single_select("\nSelect one of the following genre:", GENRE_MENU)
            puts  @user.get_recommendations_by_genre(genre, friends)
          when "Random"
            puts  @user.get_random_recommendations(friends)
        end
      else #alone
        case type_choice
          when "Top Movies"
            puts  @user.get_top_rated_recommendations
          when "By Genres"
            genre = single_select("\nSelect one of the following genre:", GENRE_MENU)
            puts  @user.get_recommendations_by_genre(genre)
          when "Random"
            puts  @user.get_random_recommendations
        end
      end
    end
  
  
  
    def reviews_operations
        choice = single_select("\nSelect one of the following:", REVIEW_OPTIONS)
        case choice
          when "Add new Review"
            add_new_review
          when "Browse my reviews"
            browser_user_reviews
          when "Show movie reviews"
            show_movie_reviews
          when "Delete an existing review"
            user_reviews = get_reviews
            user_reviews.size > 0 ? (delete_review) : (puts "\nNo review to delete")
          when "Update an existing review"
            user_reviews = get_reviews
            user_reviews.size > 0 ? (update_existing_review) : (puts "\nNo review to update")
          when "Return to main menu"
            return
        end
    end
  
    def show_movie_reviews
      movies = get_movies_by_name
      case movies.size
        when 0
          puts "\nMovie not found."
        when 1
          movies.first.latest_reviews.size > 0 ? (puts movies.first.latest_reviews) : (puts "\nNo reviews submitted for the selected movie. Be the first!")
        else
          choice = single_select("\nMultiple movies found, select one of the following:", movies.map(&:title))
          reviews =movies.find{|i| i.title == choice}.latest_reviews
          reviews.size > 0 ? (puts reviews) : (puts "\nNo reviews submitted for the selected movie. Be the first!")
      end
    end
  
    def update_existing_review
      movie_name = single_select("\nSelect one of the following:", @user.titles_of_movies_watched)
      new_rating = ask("\nLeave a new rating (1-5)") do |i|
        i.in '1-5'
        i.messages[:range?] = "You cannot vote it %{value}."
      end
      new_review = ask("\nType a new review for the movie: #{movie_name}")
      @user.update_review(movie_name, new_rating.to_i, new_review)
      @user.reload
      puts "\nYou successfully update the review of #{movie_name}"
    end
  
    def get_reviews
      @user.reviews.map(&:format_review) #refracted
    end
  
    def delete_review
      movie_name =single_select("\nSelect one of the following:", @user.titles_of_movies_watched)
      @user.delete_review(movie_name)
      @user.reload
      puts "\nYou deleted the review of #{movie_name}"
    end
  
    def browser_user_reviews
      user_reviews = get_reviews
      user_reviews.size > 0 ? (puts user_reviews) : (puts "\nYou have not reviewed anything. Get your opinion out there!")
    end
  
    def get_movies_by_name
      target_title = ask("\nWhat's the name of the movie?")
      movie_titles = Movie.list_all_titles.select{ |i| i.downcase.include?(target_title.downcase)}
      movie_titles.map {|i| Movie.find_by(title: i)}
    end
  
    def add_new_review
        movies = get_movies_by_name
        case movies.size
          when 0
            puts "Movie not found."
          when 1
            @user.movies.include?(movies.first) ? (puts "You have already reviewed this movie.") : (write_review(movies.first))
          else
            write_review(single_select("Multiple movies found, select one of the following:", movies.map(&:title)))
        end
    end
  
    def write_review(choice)
      target_rating = ask("\nHow would your rate it? (1-5)") do |i|
        i.in '1-5'
        i.messages[:range?] = 'You cannot vote %{value}.'
      end
      target_comment = ask("\nAny additional comment?")
      @user.review_movie(choice, target_rating, target_comment)
      puts "\nRewiews submitted"
      @user.reload
    end
  
    def friend_list_operations
      choice = single_select("\nSelect one of the following:", FRIENDLIST_OPTIONS)
      case choice
        when "Add new Friend"
          add_new_friend
        when "Show my FriendList"
          show_their_friends
        when "Back to main menu"
          return
        when "Delete Friend"
          delete_friend
        when "Show friend reviews"
          friend_reviews
      end
    end
  
    def friend_reviews
      temp_target_friend = single_select("\nSelect one of your friends:", @user.get_friends_names), "\n#{temp_target_friend} has the following reviews:"
      puts User.find_by(name: temp_target_friend).reviews.map(&:format_review)
    end
  
    def delete_friend
      temp_target_friend = normalizer(ask("\nWho you want to delete from your Friendlist?"))
      @user.get_friends_names.include?(temp_target_friend) ? (no_longer_friend(temp_target_friend)) : (not_friend(temp_target_friend))
    end
  
    def no_longer_friend(temp_target_friend)
      @user.delete_friend_by_name(temp_target_friend)
      puts "\nYou and #{temp_target_friend} are no longer friends..."
    end
  
    def not_friend(temp_target_friend)
      puts "\nYou and #{temp_target_friend} are not friend. AT ALL"
    end
  
  
    def add_new_friend
      temp_target_friend = normalizer(ask("\nWho would you like to add"))
      if temp_target_friend == @user.name
        puts "\nUser trying to add himself as friend, FOREVER ALONE DETECTED, COMMENCING SHUTDOWN"
      elsif User.all.map(&:name).include?(temp_target_friend)
        @user.add_friend_by_name(temp_target_friend)
        puts "\n#{@user.name} and #{temp_target_friend} are now friends!"
      else
        puts "\nUser not found, returning to FriendList menu"
      end
    end
  
    def show_their_friends
      puts "\nHeres your friend list:"
      puts get_friends_names #refracted
    end
  
    def start
      logo
      get_users_name
      welcome
      show_menu
    end
  
    def fun_facts
      choice = single_select("\nSelect one of the following:", FUN_FACTS)
      case choice
        when "Most reviewed movie"
          puts Movie.most_reviewed_movie
        when "Find the top 5 movies"
          puts Movie.top_5_movies
        when "Most active reviewer"
          puts User.most_active_reviewer
        when "How many movies does this database contains?"
          puts "\nThe database actually has #{Movie.all.size} movies"
        when "Back to main menu"
          return
      end
    end
  end