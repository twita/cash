#!/usr/bin/ruby

require 'socket'
ip = "192.168.1.11"
port = 12589

@socket = TCPSocket.new(ip, port)

Thread.new(){
	while (1)
		data=@socket.recv(1024)
		puts "RECV: #{data}"				
	end
}

while 1
	what=STDIN.gets.chop!
	puts "-> #{what}"
	@socket.send(what,0)
end



