class ProjectContribution < ActiveRecord::Base
  has_paper_trail
  belongs_to :character
  belongs_to :project

  before_save :id_to_name

  accepts_nested_attributes_for :project

  def id_to_name
    talent_object = Talent.find_by id: self.talent
    self.talent = "#{talent_object.rank} | #{talent_object.name}"
  end
end
