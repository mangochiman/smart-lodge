salt = User.random_string(10)

user = User.new
user.first_name = 'Ernest'
user.last_name = 'Matola'
user.email = 'mangochiman@gmail.com'
user.phone_number = '+265999607901'
user.username = 'mangochiman'
user.password = User.encrypt('mangochiman', salt)
user.salt = salt
user.save
