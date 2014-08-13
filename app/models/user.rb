class User < ActiveRecord::Base

	has_secure_password

    # ActiveModel Validations
	validates_presence_of :first_name, :email
  	validates_uniqueness_of :email
end
