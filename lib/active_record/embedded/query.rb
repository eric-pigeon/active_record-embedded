# frozen_string_literal: true

module ActiveRecord
  module Embedded
    # Interface for querying embedded models. Implemented by the
    # +ActiveRecord::Embedded::Relation+ and
    # +ActiveRecord::Embedded::Aggregation+ objects, and provides the
    # various SQL methods.
    module Query
      extend ActiveSupport::Concern

      include Enumerable

      included do
        attr_accessor :model, :filters, :sorts, :association, :from, :to
      end

      # @param [Model] model - Subject of aggregation
      # @param [Hash] filters - Key/value pairs to match results on
      # @param [Hash] sorts - Key/value pairs to sort results with
      # @param [Association] association - Metadata for embedded relationship
      # @param [Integer] limit - Number of results to return
      # @param [Integer] offset - Starting point in collection
      def initialize(
        model:, filters: {}, sorts: {}, association: nil, offset: 0, limit: -1
      )
        @model = model
        @filters = filters
        @sorts = sorts
        @association = association
        @from = offset
        @to = limit
      end

      # Instantiate a new model in this collection without persisting.
      #
      # @param [Hash] params - Attributes to build the model with.
      # @return [ActiveRecord::Embedded::Model]
      def build(params = {})
        association.build(model, params)
      end

      # Create a new model in this collection.
      #
      # @param [Hash] params - Attributes to build the model with.
      # @return [ActiveRecord::Embedded::Model]
      def create(params = {})
        association.build(model, params).tap(&:save)
      end

      # Create a new model in this collection, and throw an exception if
      # the operation fails.
      #
      # @param [Hash] params - Attributes to build the model with.
      # @return [ActiveRecord::Embedded::Model]
      def create!(params = {})
        association.build(model, params).tap(&:save!)
      end

      # Filter this collection by the given set of key/value pairs.
      #
      # @param [Hash] filters - Key/value pairs to filter by
      # @return [ActiveRecord::Embedded::Relation]
      def where(filters = {})
        clone.tap { |query| query.filters = filters }
      end

      # Sort this collection by the given set of keys. Values are
      # the direction, +:desc+ or +:asc+.
      #
      # @param [Hash] sorts - Key/direction pairs to sort by
      # @return [ActiveRecord::Embedded::Relation]
      def order(sorts = {})
        clone.tap { |query| query.sorts = sorts }
      end

      # Limit this collection by the given number of records.
      #
      # @param [Integer] to - Number of records to return
      # @return [ActiveRecord::Embedded::Relation]
      def limit(to = 0)
        clone.tap { |query| query.to = to - 1 }
      end

      # Begin returning records starting at the given position.
      #
      # @param [Integer] from - Start of the offset.
      # @return [ActiveRecord::Embedded::Relation]
      def offset(from = 0)
        clone.tap { |query| query.from = from }
      end

      # Find a model by the given params.
      #
      # @return [ActiveRecord::Embedded::Model] or +nil+ if nothing found
      def find_by(params = {})
        where(params).first
      end

      # Find a model by the given params. Throws an error when no record can
      # be found by any means.
      #
      # @return [ActiveRecord::Embedded::Model] if found
      # @throws [ActiveRecord::RecordNotFound] when not found
      def find_by!(params = {})
        find_by(params) || begin
          message = params.map do |key, value|
            "#{key}=#{value}"
          end
          raise RecordNotFound, message.to_sentence
        end
      end

      # Find a given model in the database by its ID.
      #
      # @param [String] ID - Unique ID for the model you wish to find
      # @return [ActiveRecord::Embedded::Model] or +nil+ if none can be found
      def find(id)
        where(id: id).first
      end

      # Find a given model in the database by its ID. Throw an error
      # when it cannot be found.
      #
      # @param [String] ID - Unique ID for the model you wish to find
      # @return [ActiveRecord::Embedded::Model] or +nil+ if none can be found
      def find!(id)
        find(id) || raise(RecordNotFound, id)
      end

      # Return a subset of the results in this query, up to the first 10.
      #
      # @return [String] Human-readable representation of this object
      def inspect
        "#<#{self.class.name} [#{inspect_entries.join(', ')}]>"
      end

      private

      def inspect_entries
        entries = if to == -1
                    take(11).map!(&:inspect)
                  else
                    take([to, 11].compact.min).map!(&:inspect)
                  end
        entries[10] = '...' if entries.size == 11
        entries
      end
    end
  end
end
