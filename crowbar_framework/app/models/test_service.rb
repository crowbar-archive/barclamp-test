# Copyright 2012, Dell 
# 
# Licensed under the Apache License, Version 2.0 (the "License"); 
# you may not use this file except in compliance with the License. 
# You may obtain a copy of the License at 
# 
#  http://www.apache.org/licenses/LICENSE-2.0 
# 
# Unless required by applicable law or agreed to in writing, software 
# distributed under the License is distributed on an "AS IS" BASIS, 
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. 
# See the License for the specific language governing permissions and 
# limitations under the License. 
# 

class TestService < ServiceObject

  def create_proposal(name)
    @logger.debug("Test create_proposal: entering")
    base = super(name)
    @logger.debug("Test create_proposal: leaving base part")

    nodes = Node.all
    nodes = nodes.select { |x| x.name =~ /^dtest/ }
    nodes = nodes.sort{|a, b| a.name <=> b.name}

    if nodes.size == 1
      add_role_to_instance_and_node(nodes[0].name, base.name, "test-single")
    elsif nodes.size > 1
      head = nodes.shift
      add_role_to_instance_and_node(head.name, base.name, "test-multi-head")
      nodes.each do |node|
        add_role_to_instance_and_node(node.name, base.name, "test-multi-rest")
      end
    end

    @logger.debug("Test create_proposal: exiting")
    base
  end

end

