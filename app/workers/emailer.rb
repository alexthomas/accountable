class Emailer
  @queue = :emailer_queue
  
  def self.perform(mailer_type,object_id,type)
    Rails.logger.debug "looking for email object with id of #{object_id}..."
    begin
      object = mailer_type.capitalize.constantize.find object_id
    rescue
      Rails.logger.debug "logging emailer worker failed to find object..."
      return
    end
    #UserMailer.complete_signup(object).deliver
    UserMailer.send(type,object).deliver
  end
  
end
