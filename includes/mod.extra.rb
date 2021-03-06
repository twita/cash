module Extra
   module Parser
      def parse_msg(data)
         glob_cmd = {:msg => {:msg => 1},
                     :privmsg => {:who => 1,:msg =>2}
                    }
          
          msg = Hash.new
          data = data.split("|")
          
          msg[:parse]=false
          return msg if data.length == 0
          type = data[0].downcase.to_sym
          return msg if glob_cmd[type].nil? or glob_cmd[type].length != data.length - 1
          
          glob_cmd[type].each{ |key,value| msg[key]=data[value]}
          
          msg[:type]=type
          msg[:parse]=true
          
         return msg
      end

   end
end
