class Project < ActiveRecord::Base
  has_paper_trail
  belongs_to :leader, :class_name => 'Character', inverse_of: :projects

  has_many :project_contributions, inverse_of: :project, dependent: :destroy
  has_many :characters, through: :project_contributions, inverse_of: :projects

  scope :latest, -> { order(updated_at: :desc) }

  validates :name, presence: true

  def total_timeunits(character=nil)
    if self.leader == character
      @total_timeunits = self.project_contributions.reduce(0) { |sum, el| sum + el.timeunits }
    else
      @total_timeunits = self.project_contributions.reduce(0) { |sum, el| sum + (el.character == character ? el.timeunits : 0) }
    end
  end

  def last_contribution(character=nil)
    if self.leader == character
      @last_contribution = self.project_contributions.order(created_at: :desc).limit(1).first.try(:created_at)
    else
      @last_contribution = self.project_contributions.where(character: character).order(created_at: :desc).limit(1).first.try(:created_at)
    end
  end

  def contributions(character=nil)
    if self.leader == character
      @contributions = self.project_contributions
    else
      @contributions = self.project_contributions.where(character: character)
    end

    @contributions.order(updated_at: :desc)
  end

  def display_name
    "#{self.name} (#{self.leader.try(:display_name)})"
  end
end
