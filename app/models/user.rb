class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :http_authenticatable, :token_authenticatable, :lockable, :timeoutable and :activatable
  devise :authenticatable, :confirmable, :recoverable, :rememberable,  :validatable
         
         # Caused failure on Rake db:migrate
         #:registerable,    
         #:trackable,

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation#, :remember_token
end
