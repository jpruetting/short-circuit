require 'delegate'

module ShortCircuit
  class Presenter < SimpleDelegator
    delegate :url_helpers, to: 'Rails.application.routes'

    def initialize(presentable_object)
      instance_variable_set("@#{presentable_object.class.to_s.underscore}", presentable_object)
      super(presentable_object)
    end

    def helpers
      ApplicationController.helpers
    end

    def error_response(error, method, *args, &block)
      ''
    end
    
    private

    def method_missing(method, *args, &block)
      if helpers.respond_to?(method)
        helpers.send(method, *args, &block)  
      elsif url_helpers.respond_to?(method)
        url_helpers.send(method, *args, &block)
      else
        super(method, *args, &block)
      end 
    end

  end
end
