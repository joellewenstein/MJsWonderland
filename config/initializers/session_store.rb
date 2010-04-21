# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_good_live_session',
  :secret      => 'fa1064a1497bee16331e2450a6eea1871bbb167217ac1b5de657885f24e20ab4d1d0ce6b719a02908e285c5ab329fa416739953753af21700195094bd003d328'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
