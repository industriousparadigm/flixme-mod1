
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

Movie.get_tmdb_movies(800)

# starwars = Movie.create(title: "Star Wars", release_year: 1977, tmdb_rating: 4.5)
# et = Movie.create(title: "E.T.", release_year: 1982, tmdb_rating: 4.55)
# roma = Movie.create(title: "Roma", release_year: 2018, tmdb_rating: 4.8)
# birdman = Movie.create(title: "Birdman", release_year: 2014, tmdb_rating: 4.4)
veronicamars = Movie.create(title: "Veronica Mars", release_year: 2014, tmdb_rating: 3.4, tmdb_synopsis: "Years after walking away from her past as a teenage private eye, Veronica Mars gets pulled back to her hometown - just in time for her high school reunion - in order to help her old flame Logan Echolls, who's embroiled in a murder mystery.")
mammamia = Movie.create(title: "Mamma Mia!", release_year: 2008, tmdb_rating: 3.5, tmdb_synopsis: "An independent, single mother who owns a small hotel on a Greek island is about to marry off the spirited young daughter she's raised alone. But, the daughter has secretly invited three of her mother's ex-lovers in the hopes of finding her biological father.")
rocknrolla = Movie.create(title: "RockNRolla", release_year: 2008, tmdb_rating: 3.5, tmdb_synopsis: "When a Russian mobster sets up a real estate scam that generates millions of pounds, various members of London's criminal underworld pursue their share of the fortune. Various shady characters, including Mr One-Two, Stella the accountant, and Johnny Quid, a druggie rock-star, try to claim their slice.")
# thebigshort = Movie.create(title: "The Big Short", release_year: 2015, tmdb_rating: 4.05)
# moana = Movie.create(title: "Moana", release_year: 2016, tmdb_rating: 4.05)
# peppa = Movie.create(title: "Peppa The Pig", release_year: 2019, tmdb_rating: 2)

riccardo.review_movie("Star Wars", 5, "what a classic!")
diogo.review_movie("Veronica Mars", 5, "marshmallows rejoice, she is BACK")
diogo.review_movie("Roma", 1, "why is this shit in black and white in 2018")
riccardo.review_movie("E.T. the Extra-Terrestrial", 4, "cute but it's kinda aged")
diogo.review_movie("Network", 4, "a bit slow but so relevant 40 years later!")
riccardo.review_movie("Veronica Mars", 2, "BOOOOORING")
sheila.review_movie("Veronica Mars", 4, "expected better from my bestie Kristen Bell")
pete.review_movie("Veronica Mars", 5)
pete.review_movie("Star Wars", 4, "i prefer documentaries")
riccardo.review_movie("Roma", 5, "this movie was dope but it has nothing to do with Italia")
sheila.review_movie("Network", 3, "everything before 2016 is shite")
manon.review_movie("Birdman", 5, "this was MINDBLOWING")
john.review_movie("Birdman", 1, "self-indulgent and pretentious")
claire.review_movie("Birdman", 5, "ed norton is so hot")
claire.review_movie("Veronica Mars", 5, "a long time agooooo we used to be friendssssss")
mariana.review_movie("Birdman", 5, "very good camerawork and brilliantly acted. so good!")
diana.review_movie("Moana", 5, "Mama! nana")
sheila.review_movie("Edge of Tomorrow", 4, "ZOMG i HAVE to do emily Blunts workout!!")
mariana.review_movie("Snatch", 5, "I find ensemble so smart and well executed and plus Jason Statham is just so hot.")
manon.review_movie("Moana", 3, "I thought this would be live action?")
manon.review_movie("Match Point", 5, "the tennis ball metaphor was genius!")
pete.review_movie("Match Point", 3, "oh come on Scarlet Johnson is SO FRIGGIN OVERRATED")
