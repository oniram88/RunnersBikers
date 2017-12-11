class AuthorizationsController < ApiController


  def check

    obj = params[:object].camelize.safe_constantize

    if obj
      if params[:id]
        obj = obj.find(params[:id])
      else
        obj = obj.new
      end
      authorize obj, "#{params[:auth_action]}?".to_sym
      respond_to do |f|
        f.json { render status: 200, json: { success: true } }
      end
    else
      raise Pundit::NotAuthorizedError, "No Object found"
    end
  rescue Exception => e

    logger.debug { e.message }

    respond_to do |f|
      f.json { render status: 401 }
    end
  end


end