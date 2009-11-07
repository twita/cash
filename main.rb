#!/usr/bin/ruby
# Cash server v2 release 091125

require File.dirname(__FILE__) + "/includes/class.cash.rb"

ip = "192.168.1.11"
port = 12589

MSG_START = ["Ca$h Server",
             "#{Time.now}",
             "Rudy emilien & Cyril Duez",
             "Version: #{CashServer::VERSION} Release: #{CashServer::RELEASE}",
             "Started on: #{ip}:#{port}"
            ]
MSG_WELCOME = ["Connected to Ca$h #{CashServer::VERSION}_#{CashServer::RELEASE}"]            
        

trap('SIGINT') {bye}
trap('SIGKILL') {bye}
trap('SIGTERM') {bye}

def bye
   @cashserver.display_msg("bye !")   
   @cashserver.shutdown
   exit
end

@cashserver = CashServer.new({:ip=>ip,:port=>port,:msg_wel => MSG_WELCOME,:timeout=>3})

system "clear"
MSG_START.each{|x| @cashserver.display_msg(x)}

begin
   @cashserver.run
rescue RuntimeError => e
   puts "Error: #{e.to_s}" #log this into file
end


while 1
	what=STDIN.gets.chop!
end




