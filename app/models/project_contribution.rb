class ProjectContribution < ActiveRecord::Base
  has_paper_trail
  belongs_to :character
  belongs_to :project

  accepts_nested_attributes_for :project
end
