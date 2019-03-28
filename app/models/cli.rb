class CLI
  MAIN_MENU= ["Rate a Movie", "Get a movie recommendation", "Friends", "Reviews", "Fun Facts", "Exit Flix-Me"]
  REVIEW_OPTIONS = ["Show movie reviews", "Browse my reviews", "Add new Review", "Update an existing review", "Delete an existing review", "Return to main menu"]
  FRIENDLIST_OPTIONS = ["Show my FriendList", "Show friend reviews", "Add new Friend", "Delete Friend", "Back to main menu"]
  FUN_FACTS = ["Find the top 5 movies", "Most reviewed movie", "Most active reviewer", "Back to main menu"]
  RECOMMEND_MENU = ["Just for me", "With friends"]
  RECOMMEND_MENU_REFINED = ["Top Movies", "By Genres", "Random"]
  GENRE_MENU = []
  #MENUS AND SUBMENUS COSTANTS ARRAYS
  def initialize
    @prompt = TTY::Prompt.new
    GENRE_MENU.concat(get_genres)
  end

  def normalizer(string)
  string.strip.split.map{|i| i.downcase.capitalize}.join(" ")
  end

  def logo
    puts "                                    FLIX-ME"
    puts "                      (Not interested in cool-flashy Logos)"
    sleep(1)
  end

  def get_users_name
    name = @prompt.ask("What's your username?")
    @user = User.find_or_create_by(name: normalizer(name))
  end

  def welcome
    puts ""
    puts "Welcome #{@user.name}!"
  end

  def get_genres
   Movie.list_all_genres
  end



  def show_menu
    puts ""
    while true
      choice = @prompt.select("What would you like to do?", MAIN_MENU)
      puts ""
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
  end

  def recommend_a_movie
    puts ""
    choice = @prompt.select("Who's watching?", RECOMMEND_MENU)
    puts ""
    case choice
    when "Just for me"
      multilple_recomendation
    when "With friends"
      friends_names = @prompt.multi_select("Select one or more of your friends:",  @user.friends.map(&:name))
      multilple_recomendation(friends_names)
    end
  end

  def multilple_recomendation(choices = [])
    friends = choices
    type_choice = @prompt.select("Select one of the following criteria:", RECOMMEND_MENU_REFINED)
    if choices.size > 0 #with friend
      case type_choice
      when "Top Movies"
        @user.get_top_rated_recommendations(friends: friends)
      when "By Genres"
        genre = @prompt.select("Select one of the following genre:", GENRE_MENU)
        @user.get_recommendations_by_genre(friends: friends, genre: genre)
      when "Random"
        @user.get_random_recommendations(friends: friends)
      end
    else #alone
      case type_choice
      when "Top Movies"
        @user.get_top_rated_recommendations
      when "By Genres"
        genre = @prompt.select("Select one of the following genre:", GENRE_MENU)
        @user.get_recommendations_by_genre(genre: genre)
      when "Random"
        @user.get_random_recommendations
      end
    end
  end



  def reviews_operations
    puts ""
    while true
      choice = @prompt.select("Select one of the following:", REVIEW_OPTIONS)
      puts ""
      case choice
      when "Add new Review"
        add_new_review
      when "Browse my reviews"
        browser_user_reviews
      when "Show movie reviews"
        show_movie_reviews
      when "Delete an existing review"
        user_reviews = get_reviews
        if user_reviews.size > 0
          delete_review
        else
          puts "No review to delete"
        end
      when "Update an existing review"
        user_reviews = get_reviews
        if user_reviews.size > 0
          update_existing_review
        else
          puts "No review to update"
        end
      when "Return to main menu"
        return
      end
    end #refracted
  end

  def show_movie_reviews
    movies = get_movies_by_name
    case movies.size
      when 0
        puts "Movie not found."
      when 1
        if movies.first.latest_reviews.size > 0
          puts movies.first.latest_reviews
        else
         puts "No reviews submitted for the selected movie. Be the first!"
        end
      else
      choice = @prompt.select("Multiple movies found, select one of the following:", movies.map(&:title))
      reviews =movies.find{|i| i.title == choice}.latest_reviews
      if reviews.size > 0
        puts reviews
      else
        puts "No reviews submitted for the selected movie. Be the first!"
      end
    end
  end

  def update_existing_review
    movie_name = @prompt.select("Select one of the following:", @user.reviews.map{ |i| i.movie.title })
    new_rating = @prompt.ask('Leave a new rating (1-5) ') do |i|
      i.in '1-5'
      i.messages[:range?] = 'You cannot vote it %{value}.'
    end
    new_review = @prompt.ask("Type a new review for the movie: #{movie_name}")
    @user.update_review(movie_name, new_rating.to_i, new_review)
    @user = User.find_or_create_by(name: @user.name)
    puts "You successfully update the review of #{movie_name}"
  end

  def get_reviews
    @user.reviews.map{|i| ["",Movie.find(i.movie_id).title, "You have rated it:#{i.rating}", i.comments]} #refracted
  end

  def delete_review
    movie_name = @prompt.select("Select one of the following:", @user.reviews.map{ |i| i.movie.title })
    @user.delete_review(movie_name)
    @user = User.find_or_create_by(name: @user.name)
    # @user = User.find_or_create_by(name: @user.name) #MAGIC!!!!!!!!!!!!!!!!!!!!!!!!!!!
    puts "You deleted the review of #{movie_name}" #refracted
  end

  def browser_user_reviews
    user_reviews = get_reviews
    if user_reviews.size > 0
      puts user_reviews
    else
      puts "You have not reviewed anything. Get your opinion out there!"
    end #refracted #refracted
  end

  def get_movies_by_name
    target_title = @prompt.ask("What's the name of the movie?").downcase
    movie_titles = Movie.all.map(&:title).select{ |i| i.downcase.include?(target_title)}
    movies = movie_titles.map {|i| Movie.find_by(title: i)}
  end

  def add_new_review
    puts ""
      movies = get_movies_by_name
      case movies.size
        when 0
          puts "Movie not found."
        when 1
          if @user.movies.include?(movies.first)
            "You have already reviewed this movie."
          else
            write_review(movies.first)
          end
        else
        choice = @prompt.select("Multiple movies found, select one of the following:", movies.map(&:title))
        write_review(choice)
      end
  end #REFRACT THIS

  def write_review(choice)
    target_rating = @prompt.ask('How would your rate it? (1-5) ') do |i|
      i.in '1-5'
      i.messages[:range?] = 'You cannot vote %{value}.'
    end
    target_comment = @prompt.ask("Any additional comment?")
    @user.review_movie(choice, target_rating, target_comment)
    puts "Rewiews submitted"
    @user.reload
  end

  def friend_list_operations
    puts ""
    while true
      puts ""
      choice = @prompt.select("Select one of the following:", FRIENDLIST_OPTIONS)
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
  end

  def friend_reviews
    puts ""
    temp_target_friend = @prompt.select("Select one of your friends:",  @user.friends.map(&:name))
    puts "", "#{temp_target_friend} has the following reviews:"
    puts User.find_by(name: temp_target_friend).reviews.map{|i| ["",Movie.find(i.movie_id).title, "With the rating of: #{i.rating}", i.comments]}
  end

  def delete_friend
    temp_target_friend = normalizer(@prompt.ask("Who you want to delete from your Friendlist?"))
    check = @user.friends.map(&:name).include?(temp_target_friend)
    if check
      @user.delete_friend_by_name(temp_target_friend)
      puts ""
      puts "You and #{temp_target_friend} are no longer friends..."
    else
      puts ""
      puts "You and #{temp_target_friend} are not friend. AT ALL"
    end
  end

  def add_new_friend
    puts ""
    temp_target_friend = normalizer(@prompt.ask("Who would you like to add"))
    if temp_target_friend == @user.name
      puts "User trying to add himself as friend, FOREVER ALONE DETECTED, COMMENCING SHUTDOWN"
    elsif User.all.map(&:name).include?(temp_target_friend)
      @user.add_friend_by_name(temp_target_friend)
      puts "#{@user.name} and #{temp_target_friend} are now friends!"
    else
      puts "User not found, returning to FriendList menu"
    end
  end

  def show_their_friends
    puts ""
    puts "Heres your friend list:"
    puts @user.friends.map(&:name) #refracted
  end

  def start
    logo
    get_users_name
    welcome
    show_menu
  end

  def fun_facts
    puts ""
    choice = @prompt.select("Select one of the following:", FUN_FACTS)
    if choice == "Most reviewed movie"
      puts Movie.most_reviewed_movie
    elsif choice == "Find the top 5 movies"
      puts Movie.top_5_movies
    elsif choice == "Most active reviewer"
      puts User.most_active_reviewer
    elsif choice == "Back to main menu"
      return
    end  #refracted
  end

end
