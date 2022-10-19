class Subscription < ApplicationRecord
    validates :users_id, presence:true
    # validates :newsletters_id, presence:true
end
 