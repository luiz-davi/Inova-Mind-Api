class Frase < ApplicationRecord
    has_many :tagfrases
    has_many :tags, through: :tagfrases

    validates :quote, uniqueness: true
end
