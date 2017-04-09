ActiveAdmin.register ProjectContribution do
  menu false

  includes project: :leader

  preserve_default_filters!
  filter :character, collection: proc { Character.all.order(name: :asc) }
  filter :project, collection: proc { Project.joins(:characters).order('characters.name asc', 'projects.name asc') }
end