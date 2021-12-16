class Frase < ApplicationRecord
    has_many :tagfrases
    has_many :tags, through: :tagfrases
end
