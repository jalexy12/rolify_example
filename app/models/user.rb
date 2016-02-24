class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :locations
  has_many :posts

  accepts_nested_attributes_for :locations
  
  rolify strict: true
  
  after_create :assign_default_role

  private 

	def assign_default_role
	 add_role(:default_user) if self.roles.blank?
	end
end
