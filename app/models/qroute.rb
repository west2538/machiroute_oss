class Qroute < ApplicationRecord
    belongs_to :post, touch: true
    geocoded_by :qplacename
    after_validation :geocode
end
