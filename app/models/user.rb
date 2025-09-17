class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  validates :first_name, presence: true
  validates :last_name, presence: true
  
  enum :user_status, {pending: 0, approved: 1, deactivated: 2}
  enum :user_role, {trader: 0, admin: 1 }

  has_one :wallet
end
