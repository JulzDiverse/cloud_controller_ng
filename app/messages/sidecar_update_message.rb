require 'messages/base_message'

module VCAP::CloudController
  class SidecarUpdateMessage < BaseMessage
    register_allowed_keys [:name, :command, :process_types]

    validates_with NoAdditionalKeysValidator

    validates :name, presence: true, string: true, if: ->(message) { message.requested?(:name) }
    validates :command, presence: true, string: true, if: ->(message) { message.requested?(:command) }
    validates :process_types, array: true, length: {
      minimum: 1,
      too_short: 'must have at least %{count} process_type'
    }, if: ->(message) { message.requested?(:process_types) }
  end
end
