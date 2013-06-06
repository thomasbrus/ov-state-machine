client = new Faye.Client('/faye')
client.publish('/foo', text: 'Hi there')
