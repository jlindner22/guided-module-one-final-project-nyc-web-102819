class Fight < ActiveRecord::Base
    belongs_to :player
    belongs_to :enemy
end