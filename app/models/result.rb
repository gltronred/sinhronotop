class Result < ActiveRecord::Base
  belongs_to :team
  belongs_to :event
  has_many :resultitems, :dependent => :delete_all
  
  def calculate_and_save
    self.score = self.resultitems.select{|item| item.score == 1}.length
    self.save
  end
  
  def items_for_tour(tour) 
    self.resultitems.find_all{|item| (item.question_index-1) / self.event.game.num_questions == tour-1 }
  end
  
  def score_for_tour(tour)
    items_for_tour(tour).select{|item| item.score == 1}.length
  end
  
  def tour_for_question(question_index)
    (question_index-1)/self.event.game.num_questions+1
  end
end
