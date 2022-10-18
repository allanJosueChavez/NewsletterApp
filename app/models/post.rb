class Post < ApplicationRecord
    validates :users_id, presence:true
    validates :newsletters_id, presence:true
    validates :title, presence:true
    validates :description, presence:true
end
