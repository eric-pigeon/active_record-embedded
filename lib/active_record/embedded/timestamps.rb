module ActiveRecord
  module Embedded
    module Timestamps
      extend ActiveSupport::Concern

      included do
        field :created_at, type: Time, default: -> { Time.current }
        field :updated_at, type: Time, default: -> { Time.current }
      end
    end
  end
end
