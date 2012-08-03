FactoryGirl.define do
  factory :device_property, aliases: %w(device_status) do
    uri   "https://api.lelylan.com/properties/#{Settings.resource_id}"
    value 'on'
  end

  factory :device_intensity, parent: :device_property do
    uri   "https://api.lelylan.com/properties/#{Settings.another_resource_id}"
    value '100'
  end
end
