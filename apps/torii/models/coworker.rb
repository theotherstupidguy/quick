require_relative '../../core/lib/model'
require 'bcrypt'

module Spotime
  module Models
    class Coworker
      include Spotime::Core::Model
      include BCrypt

      attr_accessor :password, :password_confirmation
      attr_protected :password_hash
      field :email, :type => String
      field :password_hash, :type => String
      field :accept_terms, :type => Boolean

      field :name, :type => String
      field :about, :type => String
      field :avatar_url, :type => String

      field :gender, :type => String
      field :locale, :type => String


      validates_presence_of :email, :message => "Email Address is Required."
      validates_uniqueness_of :email, :message => "Email Address Already In Use. Have You Forgot Your Password?"
      validates_format_of :email, :with => /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i, :message => "Please Enter a Valid Email Address."

      validates_presence_of :name, :message => "Name is Required."
      validates_uniqueness_of :name, :message => "Name Already In Use. choose another one please"
      #						validates_format_of :name, :with => [^A-Za-z0-9_.], :message => "Please Enter a Valid Name"



      validates_acceptance_of :accept_terms, :allow_nil => false, :accept => true, :message => "Terms and Conditions Must Be Accepted."
      validates_length_of :password, :minimum => 8, :message => "Password Must Be Longer Than 8 Characters."
      validates_confirmation_of :password, :message => "Password Confirmation Must Match Given Password."
      before_save :encrypt_password

      def self.find_by_email(email)
	#		first(conditions: { email: email })
	Spotime::Models::Coworker.find_by(email: email)
      end
      def self.authenticate(email, password)
	if password_correct?(email, password)
	  # Success!
	  true
	else
	  # Failed! :(
	  false
	end
      end
      def self.password_correct?(user_email, password)
	user = find_by_email user_email
	return if user.nil?
	user_pass = Password.new(user.password_hash)
	user_pass == password
      end
      protected
      def encrypt_password
	self.password_hash = Password.create(@password)
      end
    end
  end
end

#field :email, type: String
#field :password, type: String 

#field :password, type: BCryptHash 
#field :username, type: String
#field :fullname, type: String
#field :about, type: String
#field :avatar, type: String #avatar picture url

#validates_uniqueness_of :username
#validates_uniqueness_of :email

#validates_presence_of :username
#validates_presence_of :email
#validates_presence_of :password

#index :username, unique: true
#
