class Newsletter < ApplicationRecord
    has_many :posts, foreign_key: "newsletters_id", dependent: :destroy
    has_many :subscriptions, foreign_key: "newsletters_id", dependent: :destroy

    # validates :r_rated, presence:true
    validates :name, presence:true
    validates :topic, presence:true
    validates :users_id, presence:true
end
