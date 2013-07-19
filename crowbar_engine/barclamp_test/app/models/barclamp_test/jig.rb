# Copyright 2013, Dell
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
#
# This model is a stub for the Jig override system
# It is NOT installed by default, but can be used for testing or as a model

require 'json'

class BarclampTest::Jig < Jig

  def run(nr)
    raise "Cannot call TestJig::Run on #{nr.name}" unless nr.state == NodeRole::TRANSITION
    # Hardcode this for now
    begin
      puts "ZEHICLE test jig running #{nr.inspect}"
      %x[touch /tmp/test-jig-node-role-#{nr.node.name}]
      nr.state = NodeRole::ACTIVE
    rescue
      nr.state = NodeRole::ERROR
    end
  end

  def create_node(node)
    puts "ZEHICLE test jig create #{node.inspect}"
    %x[touch /tmp/test-jig-node-#{node.name}]
    Rails.logger.info("TestJig Creating node: #{node.name}")
  end

  def delete_node(node)
    puts "ZEHICLE test jig delete #{node.inspect}"
    %x[rm /tmp/test-jig-node-#{node.name}]
    Rails.logger.info("TestJig Deleting node: #{node.name}")    
  end
  
end


