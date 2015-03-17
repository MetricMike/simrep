class Project < ActiveRecord::Base
  has_paper_trail
  belongs_to :leader, :class_name => 'Character'

  has_many :project_contributions
  has_many :characters, through: :project_contributions

  validates :name, presence: true

  def total_timeunits(character=nil)
    if self.leader == character or character.nil?
      @total_timeunits = self.project_contributions.reduce(0) { |sum, el| sum + el.timeunits }
    else
      @total_timeunits = self.project_contributions.reduce(0) { |sum, el| sum + (el.character == character ? el.timeunits : 0) }
    end
  end

  def last_contribution(character=nil)
    if self.leader == character or character.nil?
      @last_contribution = self.project_contributions.order(updated_at: :desc).limit(1).first.try(:updated_at)
    else
      @last_contribution = self.project_contributions.where(character: character).order(updated_at: :desc).limit(1).first.try(:updated_at)
    end
  end
end
