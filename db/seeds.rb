
        require 'rest-client'
require 'json'
Movie.destroy_all
User.destroy_all
Review.destroy_all
Friendship.destroy_all

riccardo = User.create(name: "Riccardo")
diogo = User.create(name: "Diogo")
manon = User.create(name: "Manon")
john = User.create(name: "John")
claire = User.create(name: "Claire")
sheila = User.create(name: "Sheila")
jack = User.create(name: "Jack")
pete = User.create(name: "Pete")
mariana = User.create(name: "Mariana")
diana = User.create(name: "Diana")

f1 = Friendship.create(user: riccardo, friend_id: diogo.id)
f2 = Friendship.create(user: diogo, friend_id: pete.id)
f3 = Friendship.create(user: riccardo, friend_id: manon.id)
f4 = Friendship.create(user: sheila, friend_id: riccardo.id)
f5 = Friendship.create(user: sheila, friend_id: diogo.id)
f6 = Friendship.create(user: claire, friend_id: sheila.id)
f7 = Friendship.create(user: riccardo, friend_id: john.id)
f8 = Friendship.create(user: mariana, friend_id: diogo.id)
f9 = Friendship.create(user: diana, friend_id: mariana.id)

starwars = Movie.create(title: "Star Wars", release_year: 1977, tmdb_rating: 9)
et = Movie.create(title: "E.T.", release_year: 1982, tmdb_rating: 9.1)
roma = Movie.create(title: "Roma", release_year: 2018, tmdb_rating: 9.6)
birdman = Movie.create(title: "Birdman", release_year: 2014, tmdb_rating: 8.8)
veronicamars = Movie.create(title: "Veronica Mars", release_year: 2014, tmdb_rating: 6.2)
mammamia = Movie.create(title: "Mamma Mia!", release_year: 2008, tmdb_rating: 5.1)
greenbook = Movie.create(title: "Green Book", release_year: 2018, tmdb_rating: 6.9)
network = Movie.create(title: "Network", release_year: 1976, tmdb_rating: 8.8)
thebigshort = Movie.create(title: "The Big Short", release_year: 2015, tmdb_rating: 8.1)
moana = Movie.create(title: "Moana", release_year: 2016, tmdb_rating: 8.1)
peppa = Movie.create(title: "Peppa The Pig", release_year: 2019, tmdb_rating: 4)

Movie.all.each { |movie| movie.tmdb_rating = movie.tmdb_rating / 2 }

riccardo.review_movie(starwars.title, 5, "what a classic!")
diogo.review_movie(veronicamars.title, 5, "marshmallows rejoice, she is BACK")
diogo.review_movie(roma.title, 1, "why is this shit in black and white in 2018")
riccardo.review_movie(et.title, 4, "cute but it's kinda aged")
diogo.review_movie(network.title, 4, "a bit slow but so relevant 40 years later!")
riccardo.review_movie(veronicamars.title, 2, "BOOOOORING")
sheila.review_movie(veronicamars.title, 4, "expected better from my bestie Kristen Bell")
pete.review_movie(veronicamars.title, 5)
pete.review_movie("Star Wars", 4, "i prefer documentaries")
riccardo.review_movie("Roma", 5, "this movie was dope but it has nothing to do with Italia")
sheila.review_movie("Network", 3, "everything before 2016 is shite")
manon.review_movie("Birdman", 5, "this was MINDBLOWING")
john.review_movie("Birdman", 1, "self-indulgent and pretentious")
claire.review_movie("Birdman", 5, "ed norton is so hot")
claire.review_movie("Veronica Mars", 5, "a long time agooooo we used to be friendssssss")
mariana.review_movie("Birdman", 5, "very good camerawork and brilliantly acted. so good!")
diana.review_movie("Moana", 5, "Mama! nana")

Movie.get_tmdb_movies