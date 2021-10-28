# frozen_string_literal: true

require 'test_helper'

module ActiveRecord
  module Embedded
    class MacrosTest < ActiveSupport::TestCase
      class TestClass
        include Embedded
      end

      let(:klass) { TestClass }

      teardown do
      end

      describe :embeds_one do
        it "defines the association on the class" do
          klass.embeds_one :sample
          refute_nil klass.embeds[:sample]
        end
      end

      describe :embeds_many do
        # TODO
      end
    end
  end
end
