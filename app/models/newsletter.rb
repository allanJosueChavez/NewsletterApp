class Newsletter < ApplicationRecord
    has_many :posts
    validates :r_rated, presence:true
    validates :title, presence:true
    validates :topic, presence:true
    validates :users_id, presence:true
end
