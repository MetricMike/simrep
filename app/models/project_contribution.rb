class ProjectContribution < ActiveRecord::Base
  has_paper_trail
  belongs_to :character, inverse_of: :project_contributions
  belongs_to :project, ->{ includes(:leader) }, inverse_of: :project_contributions

  before_create :invest_talent

  accepts_nested_attributes_for :project, allow_destroy: true

  def invest_talent
    self.character.invest_in_project(self.timeunits, self.talent)
    self.talent = Talent.find(self.talent).display_name if self.talent.present?
  end

  def display_name
    "#{self.character.display_name} to #{self.project.display_name} with #{self.talent} (#{self.timeunits})"
  end
end
