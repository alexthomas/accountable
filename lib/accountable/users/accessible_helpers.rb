module Accountable
  module Users
    module AccessibleHelpers
  
      def accessible_ids(current_ability)
        self.accessible_by(current_ability).map { |object| object.id}
      end
  
    end
  end
end