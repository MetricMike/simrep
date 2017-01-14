module Api
  module V1
    class ChapterResource < ApiResource
      immutable
      attributes :name, :default_xp, :default_skills
    end
  end
end
