module Api
  module V1
    class ApiController < ApplicationController
      include JSONAPI::ActsAsResourceController
      rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

      protect_from_forgery with: :null_session

      private

      def context
        {user: pundit_user}
      end

      def user_not_authorized
        head :forbidden
      end
    end
  end
end
