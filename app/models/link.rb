class Link < ActiveRecord::Base
  belongs_to :tournament
  belongs_to :game

  validates_length_of :url, :maximum => 255, :message => 'Максимальная длина - 256 символов.'
end
