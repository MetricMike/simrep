module ActiveAdmin
  module Views
    class Footer < Component

      def build
        super :id => "footer"
        powered_by_message
      end

    end
  end
end