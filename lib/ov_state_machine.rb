require 'dm-yaml-adapter'

require_relative 'ov_state_machine/carrier'
require_relative 'ov_state_machine/location'

DataMapper.setup(:default, "yaml:db")
DataMapper.finalize

require_relative 'ov_state_machine/journey'
require_relative 'ov_state_machine/transit_card'
require_relative 'ov_state_machine/event_dispatcher'
require_relative 'ov_state_machine/jtorx_client'
require_relative 'ov_state_machine/web'
