module Faker
  class SimTerra < Base
    class << self
      def race
        fetch('simterra.race')
      end

      def culture
        fetch('simterra.culture')
      end
    end
  end
end