class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  scope :pending_users, -> { where("user_status == pending") }

  validates :first_name, presence: true
  validates :last_name, presence: true

  enum :user_status, { buyer_only: 0, buyer_broker: 1, deactivated: 2, pending: 3 }
  enum :user_role, { buyer: 0, admin: 1, broker: 2 }

  has_one :wallet

  after_create :create_wallet

  private
  def create_wallet
    Wallet.create!(
      user: self,
      balance: 0,
    )
  end
end
