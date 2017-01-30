# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_smart-lodge_session',
  :secret      => 'a2ae863206212d15c86eb5a329005daeb5b26a9bff64afd06778f4b82a2cc3566256e2a064cc84eb076ee62aa1c94ffca71a34b66af7674c4f40da1211e65c9c'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
