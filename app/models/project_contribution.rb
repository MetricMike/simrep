class ProjectContribution < ActiveRecord::Base
  has_paper_trail
  belongs_to :character, inverse_of: :project_contributions
  belongs_to :project, inverse_of: :project_contributions

  default_scope { order(updated_at: :desc) }

  before_create :invest_talent, if: Proc.new { |project_contribution| project_contribution.talent.present? }

  accepts_nested_attributes_for :project, allow_destroy: true

  def invest_talent
    self.character.invest_in_project(self.timeunits, self.talent)
    self.talent = Talent.find(self.talent).display_name
  end

  def display_name
    "#{self.character.display_name} to #{self.project.display_name} with #{self.talent} (#{self.timeunits})"
  end
end
