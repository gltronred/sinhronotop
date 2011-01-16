class User < ActiveRecord::Base
  def to_s
    "#{self.email} (#{self.role})" 
  end
end
