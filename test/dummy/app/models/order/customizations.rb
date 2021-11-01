# frozen_string_literal: true

class Order::Customizations
  include ActiveRecord::Embedded::Model
  include ActiveRecord::Embedded::DynamicAttributes
  include ActiveRecord::Embedded::Timestamps

  embedded_in :order

  field :id, default: -> { SecureRandom.uuid }
  field :foo
end
