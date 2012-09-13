class InviteCodeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    association = options[:association]
    if value.nil? || record.send(association).nil? || (!record.send(association).nil? && record.send(association).invite_code!=value)
      record.errors[attribute] << "#{value} is not a valid invite code"
    end
  end
end