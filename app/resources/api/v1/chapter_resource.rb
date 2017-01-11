module Api
  module V1
    class ChapterResource < ApiResource
      immutable
      attributes :name, :default_xp
    end
  end
end
