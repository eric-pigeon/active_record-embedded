# frozen_string_literal: true

require 'test_helper'

module ActiveRecord
  class EmbeddedTest < ActiveSupport::TestCase
    test 'initialize!' do
      ActiveRecord::Embedded.initialize!('sqlserver')

      assert ActiveRecord::Embedded.config.serialize_data
    end
  end
end
