class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :age, presence:true, numericality:true
  has_many :newsletters, foreign_key: "users_id", dependent: :destroy
  has_many :posts, foreign_key: "users_id", dependent: :destroy
  has_many :subscribtions, foreign_key: "users_id", dependent: :destroy

end
