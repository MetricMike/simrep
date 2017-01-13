module Api
  module V1
    class ChapterResource < ApiResource
      immutable
      attributes :name, :default_xp
      attribute :default_skills

      def default_skills
        Character.skill_points_for_experience(default_xp)
      end

    end
  end
end
