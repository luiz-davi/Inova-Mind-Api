class Tag < ApplicationRecord
    has_many :tagfrases
    has_many :frases, through: :tagfrases

    validates :nome, uniqueness: true
end
