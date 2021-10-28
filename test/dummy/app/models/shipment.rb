# frozen_string_literal: true

class Shipment < ApplicationRecord
  include ActiveRecord::Embedded

  belongs_to :order

  embeds_many :items, class_name: 'Shipment::Item'
end
