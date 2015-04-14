class ProjectContribution < ActiveRecord::Base
  has_paper_trail
  belongs_to :character, inverse_of: :project_contributions
  belongs_to :project, inverse_of: :project_contributions

  before_save :id_to_name

  accepts_nested_attributes_for :project, allow_destroy: true

  def id_to_name
    if self.talent.present?
      talent_object = Talent.find_by id: self.talent
      self.talent = "#{talent_object.rank} | #{talent_object.name}"
    end
  end
end
