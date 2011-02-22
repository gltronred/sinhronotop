class Result < ActiveRecord::Base
  belongs_to :team
  belongs_to :event
  has_many :resultitems, :dependent => :delete_all
  validates_presence_of :cap_name, :if => :should_validate_cap_name?
  
  
  def calculate_and_save
    self.score = get_score self.resultitems
    self.save
  end
  
  def should_validate_cap_name?
    self.event.game.tournament.cap_name_required
  end
  
  def items_for_tour_sorted(tour) 
     items_for_tour(tour).sort{|x,y| x.question_index <=> y.question_index}
  end
  
  def score_for_tour(tour)
    get_score items_for_tour(tour)
  end
  
  def place_to_s
    if self.place_begin && self.place_end
      self.place_begin == self.place_end ? self.place_begin : "#{self.place_begin}-#{self.place_end}"
    else
      ""
    end
  end
  
  def tour_for_question(question_index)
    (question_index-1)/self.event.game.num_questions+1
  end
  
  def create_resultitems
    for i in 1..self.event.game.num_tours*self.event.game.num_questions
      params =
      { :result_id      => self.id,
        :question_index => i,
        :score          => 0 }
      resultitem = Resultitem.new(params)
      resultitem.save
    end
  end
  
  def to_s
    self.score
  end
  
  private
  
  def get_score(items)
    items.map(&:score).count(1)
  end
  
  def items_for_tour(tour) 
    self.resultitems.select{|item| (item.question_index-1) / self.event.game.num_questions == tour-1 }
  end
  
  def get_parent
    self.event
  end
    
end
