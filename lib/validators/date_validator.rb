class DateValidator < ActiveModel::EachValidator
  
  RESTRICTIONS = {
        :is_at        => :==,
        :before       => :<,
        :after        => :>,
        :on_or_before => :<=,
        :on_or_after  => :>=,
      }.freeze

  DEFAULT_ERROR_VALUE_FORMATS = {
    :date => '%Y-%m-%d',
    :time => '%H:%M:%S',
    :datetime => '%Y-%m-%d %H:%M:%S'
  }.freeze

  RESTRICTION_ERROR_MESSAGE = "Error occurred validating %s for %s restriction:\n%s"

  # def self.kind
  #   :timeliness
  # end
  
  def validate_each(record, attribute, value)
    Rails.logger.debug " options in validate each of date validator: #{options.inspect}"
    validate_restrictions(record,value)
    
  end
  
  def calculate_restriction_value(record,restriction,value)
    value = value.is_a?(Symbol) && record.class.respond_to?(value) ? record.class.send(value) : value
    value = value.is_a?(Symbol) && record.respond_to?(value) ? record.send(value): value
    value 
  end
  
  def validate_restrictions(record,value)
    Rails.logger.debug "record: #{record.inspect}"
    options.each do |restriction,rv|
      next unless RESTRICTIONS.include?(restriction)
      rv = calculate_restriction_value(record,restriction,rv)
      self.send(RESTRICTIONS[restriction],value,rv)
    end
    
  end
  
  def method_missing(name, *args)
      Rails.logger.debug "in method missing for date validation #{name}: #{args[0]}"
    end
end