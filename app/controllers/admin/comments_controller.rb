module Admin
  class CommentsController < BaseController
    include Admin::CrudActions

    def create
      @resource = Comment.new(resource_params)
      @resource.author = current_user
      @resource.namespace ||= "admin"
      authorize_resource @resource
      if @resource.save
        redirect_back fallback_location: admin_comments_path, notice: "Comment added."
      else
        redirect_back fallback_location: admin_comments_path, alert: @resource.errors.full_messages.to_sentence
      end
    end

    private

    def resource_params
      params.require(:comment).permit(:body, :namespace, :resource_type, :resource_id)
    end
  end
end
