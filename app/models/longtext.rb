class Longtext < ActiveRecord::Base
  belongs_to :tournament
  belongs_to :game

  validates_length_of :title, :maximum => 100
  validates_length_of :value, :maximum => 20000, :message => 'Максимальная длина - 20000 символов. Попробуйте разместить большое текст как несколько небольших'

  def get_max_length
    200000
  end
end
