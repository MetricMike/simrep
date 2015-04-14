module ActiveAdmin
  module Views
    class Footer < Component

      def build
        super :id => "footer"
        powered_by_message

        div do
          console
        end
      end

    end
  end
end