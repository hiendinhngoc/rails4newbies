class User < ActiveRecord::Base
	attr_accessor :password
	EMAIL_REGEX = /\A[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\z/i
	validates :username, :presence => true, :uniqueness => true, :length => { :in => 3..20 }
	validates :email, :presence => true, :uniqueness => true, :format => EMAIL_REGEX
	validates :password, :confirmation => true
	validates_length_of :password, :in => 6..20, :on => :create

	before_save :encrypt_password
	after_save :clear_password

	def encrypt_password
		self.encrypted_password = BCrypt::Password.create(password) if password.present?
	end

	def clear_password
		self.password = nil
	end

	def self.authenticate(username_or_email="", login_password="")
		if EMAIL_REGEX.match(username_or_email)
			user = User.find_by_email(username_or_email)
		else
			user = User.find_by_username(username_or_email)
		end

		if user && user.match_password(login_password)
			return user
		else
			return false
		end
	end

	def match_password(login_password="")
    	BCrypt::Password.new(encrypted_password) == login_password
	end

	private

	def user_parameters
		params.require(:user).permit(:username, :email, :password)
	end
end
