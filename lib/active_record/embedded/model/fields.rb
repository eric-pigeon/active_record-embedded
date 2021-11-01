# frozen_string_literal: true

module ActiveRecord
  module Embedded
    module Model
      # Define fields for an embedded model. Contains the top-level
      # +fields+ object that contains all fields defined on the model.
      # This module also configures some fields necessary for the model,
      # such as timestamps and the +:id+.
      module Fields
        extend ActiveSupport::Concern

        included do
          class_attribute :fields
          self.fields ||= {}
        end

        class_methods do
          # Define an embedded field.
          #
          # @param [Symbol] name - Name of the field
          # @param [Class] type - Class of the field type
          # @param [Object|Proc] default (optional) - Default value
          def field(name, type: String, default: nil)
            fields[name] = field = Field.create(
              type: type, name: name, default: default
            )
            define_method(name) do
              self[name] || public_send(field.default_method_name)
            end
            define_method("#{name}=") { |value| self[name] = value }
            return unless field.default?

            define_method(field.default_method_name, field.default)
          end

          # Names of all fields defined on this model.
          #
          # @return [Array<Symbol>]
          def field_names
            fields.keys
          end
        end
      end
    end
  end
end
