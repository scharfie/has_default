module HasDefault
  module ClassMethods
    attr_accessor :has_default_values
    
    def has_default_values
      @has_default_values ||= {}
    end
    
    def has_default(attribute, &block)
      has_default_values[attribute] = block
      
      define_method(attribute) do
        block.call(self)
      end
    end
  end
  
  module InstanceMethods
    def ensure_has_default_values
      self.class.has_default_values.each do |attribute, block|
        block.call(self)
      end
    end
  end
  
  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
    receiver.send :before_validation, :ensure_has_default_values
  end
end