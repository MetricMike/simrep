class Project < ActiveRecord::Base
  belongs_to :leader, :class_name => 'Character'
  
  has_many :character_projects
  has_many :characters, through: :character_projects
  
  validates :name, presence: true
end
