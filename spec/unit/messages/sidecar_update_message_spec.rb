require 'spec_helper'
require 'messages/sidecar_update_message'

module VCAP::CloudController
  RSpec.describe SidecarUpdateMessage do
    let(:body) do
      {
        name: 'my sidecar',
        command: 'bundle exec rackup',
        process_types: ['web', 'worker']
      }
    end

    describe 'validations' do
      it 'validates happy path' do
        message = SidecarUpdateMessage.new(body)
        expect(message).to be_valid
      end

      context 'partially updating name' do
        let(:body) do
          { name: 'my ssidecar' }
        end

        it 'validates happy path' do
          message = SidecarUpdateMessage.new(body)
          expect(message).to be_valid
        end
      end

      context 'partially updating command' do
        let(:body) do
          { command: 'rackup' }
        end

        it 'validates happy path' do
          message = SidecarUpdateMessage.new(body)
          expect(message).to be_valid
        end
      end

      context 'partially updating process_types' do
        let(:body) do
          { process_types: ['other_worker'] }
        end

        it 'validates happy path' do
          message = SidecarUpdateMessage.new(body)
          expect(message).to be_valid
        end
      end

      it 'validates that there are not excess fields' do
        body[:updated_at] = 'field'
        message = SidecarUpdateMessage.new(body)

        expect(message).to_not be_valid
        expect(message.errors.full_messages).to include("Unknown field(s): 'updated_at'")
      end

      it 'validates name is present' do
        body[:name] = ''
        message = SidecarUpdateMessage.new(body)

        expect(message).to_not be_valid
        expect(message.errors.full_messages).to include("Name can't be blank" )
      end

      it 'validates command is present' do
        body[:command] = ''
        message = SidecarUpdateMessage.new(body)

        expect(message).to_not be_valid
        expect(message.errors.full_messages).to include("Command can't be blank")
      end

      it 'validates command is less than or equal to 4096 characters' do
        body[:command] = 'a' * 4097
        message = SidecarUpdateMessage.new(body)

        expect(message).to_not be_valid
        expect(message.errors.full_messages).to include('Command is too long (maximum is 4096 characters)')
      end

      it 'validates that there is at least one process_type' do
        body[:process_types] = []
        message = SidecarUpdateMessage.new(body)

        expect(message).to_not be_valid
        expect(message.errors.full_messages).to include('Process types must have at least 1 process_type')
      end

    end
  end
end
