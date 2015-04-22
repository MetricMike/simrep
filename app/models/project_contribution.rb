class ProjectContribution < ActiveRecord::Base
  has_paper_trail
  belongs_to :character, inverse_of: :project_contributions
  belongs_to :project, inverse_of: :project_contributions

  before_save :invest_talent

  accepts_nested_attributes_for :project, allow_destroy: true

  def invest_talent
    self.character.invest_in_project(self.timeunits, self.talent)
    self.id_to_name
  end

  def id_to_name
    talent_object = Talent.find_by id: self.talent
    self.talent = "#{talent_object.rank} | #{talent_object.group}: #{talent_object.name}"
  end
end
