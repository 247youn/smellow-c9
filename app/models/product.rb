class Product < ActiveRecord::Base
    belongs_to :evaluation
    belongs_to :comment
end
