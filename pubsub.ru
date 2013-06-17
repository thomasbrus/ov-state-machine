require 'faye'

Faye::WebSocket.load_adapter('thin')
run Faye::RackAdapter.new(mount: '/pubsub')
