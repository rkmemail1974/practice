class Game < ActiveRecord::Base
 has_many :players, dependent: :destroy
 has_many :territorys, dependent: :destroy
end
