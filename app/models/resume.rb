class Resume < ApplicationRecord
  belongs_to :student
  enum status: { 'oculto': 1, 'ativo': 2 }
end
