# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_savedenki_session',
  :cookie_only => false,
  :secret      => '50f598c1e73dbe6f171deb548097770ec8b15b0c5ae9b7b8c7acd5e94ff84c23552d5bf1626088c95a00bdee0d26e5a369858b58b59c8e43618f63d1846476f1'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
ActionController::Base.session_store = :active_record_store
