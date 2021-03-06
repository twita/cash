#!/usr/bin/ruby
# Cash server v2

require 'socket'
require 'timeout'

require File.dirname(__FILE__) + "/class.client.rb"
require File.dirname(__FILE__) + "/mod.extra.rb"

class CashServer
   VERSION = "2"
   RELEASE = Time.now.strftime("%y.%m%d")

   include Extra::Parser

   def initialize(opt)
      @config = {:ip => "127.0.0.1",:port => 12589,:msg_wel => ["Connected to Ca$h #{CashServer::VERSION}_#{CashServer::RELEASE}"],:timeout => 300}
      @config.merge!(opt)
      @clients = Array.new
   end
   
   def run
      main_socket = TCPServer.new(@config[:ip], @config[:port]) rescue (raise "Unable to listen #{@config[:ip]}:#{@config[:port]}")
      while 1
         sock_client = main_socket.accept rescue (raise "Lost main socket")
         new_client = Client.new(sock_client)
         new_thread = Thread.new(new_client){ |client|
            while 1
               data = String.new
               reason="quit"
               begin
                  Timeout::timeout(@config[:timeout]) {
                     data = client.socket.recv(1024)
                  }
               rescue Timeout::Error
                  reason="timeout"
               end
               if data.empty?
                  client_quit(client,"quit")
                  Thread.exit
               end
               display_msg(data)
               hash=parse_msg(data)
               self.method("on_#{hash[:type]}").call(hash) if(hash[:parse] and self.respond_to?("on_#{hash[:type]}"))
            end
         }
      @clients << new_client
      display_msg("[#{@clients.length}] New client: #{new_thread}")
      @config[:msg_wel].each{|x| send_cmd(sock_client,x)}
      end
   end
   
   def shutdown
      @main_socket.shutdown(2) unless @main_socket.nil? 
   end
   
   def send_cmd(sock,text)
      sock.send(text,0)
   end
   
   def on_msg(opt)
   puts "on msg"
   p opt
   end
   
   def display_msg(text)
      puts "<- #{Time.now.strftime("%H:%M:%S")} - #{text}"
   end
   
   private
   
   def client_quit(client,reason="quit")
     client.socket.shutdown(2)
     @clients.delete_if{ |link| link.object_id == client.object_id}
     display_msg("[#{@clients.length}] Client disconnected: #{reason} ")
   end


end

