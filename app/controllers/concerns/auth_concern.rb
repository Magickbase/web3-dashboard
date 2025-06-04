module AuthConcern
  extend ActiveSupport::Concern

  included do
    helper_method :current_user
  end

  def authenticate_user!(register: false)
    subject = extract_subject!
    unless subject
      raise ApiError::UnauthorizedError.new("unauthorized: missing required X-Subject-ID header or subject parameter")
    end

    @current_user =
      if register
        User.find_or_create_by!(subject:)
      else
        begin
          User.find_by!(subject: subject)
        rescue ActiveRecord::RecordNotFound
          raise ApiError::UnauthorizedError.new("user(#{subject}) not found")
        end
      end
  end

  def current_user
    @current_user
  end

  private

  def extract_subject!
    request.headers["X-Subject-ID"] || params[:subject]
  end
end
