# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_chgk_session',
  :secret      => '5b7fc91e447ed03439918cdd306716e51c92c2c52bbb70c6f2421868b160774165b5df6c58d08e7437bb3b1ab048d9b09013981e215a4d7f390c0c6235ae21e6'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
