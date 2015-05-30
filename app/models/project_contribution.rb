class ProjectContribution < ActiveRecord::Base
  has_paper_trail
  belongs_to :character, inverse_of: :project_contributions
  belongs_to :project, inverse_of: :project_contributions

  before_create :invest_talent, if: Proc.new { |project_contribution| project_contribution.talent.present? }

  accepts_nested_attributes_for :project, allow_destroy: true

  def invest_talent
    self.character.invest_in_project(self.timeunits, self.talent)
    self.talent = Talent.find(self.talent).friendly_name
  end
end
