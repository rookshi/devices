class FunctionsController < ApplicationController
  before_filter :find_owned_resources
  before_filter :find_resource
  before_filter :find_function
  before_filter :merge_properties
  before_filter :status

  def update
    @device = @device.synchronize_device(@properties)
    params  = {device_uri: DeviceDecorator.decorate(@device).uri, created_from: current_user.uri}
    History.create_history(params, @device.device_properties)
    render '/devices/show', status: @status
  end

  private 

    def find_owned_resources
      @devices = Device.where(created_from: current_user.uri)
    end

    def find_resource
      @device = @devices.find(params[:id])
    end

    def find_function
      type = Lelylan::Type.type(@device.type_uri)
      @function = type.functions.select{ |function| function.uri == params[:uri] }.first
      render_404 'notifications.function.not_found', params[:uri] if not @function
    end

    def merge_properties
      @properties = body_properties
      function_properties = @function.properties.map {|property| {uri: property.uri, value: property.value}}
      function_properties.each do |property|
        @properties.push(property) unless contains_property(property[:uri])
      end
    end

    def status
      @status = @device.device_physical ? 202 : 200
    end

      # -----------------
      # Helper methods
      # -----------------
      def body_properties
        @body = request.body.read
        @body = @body.empty? ? nil : JSON.parse(@body)
        @properties = @body ? @body['properties'] : []
      end

      def contains_property(uri)
        @properties.any? {|property| property.has_value? uri}
      end
end
