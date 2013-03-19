# Copyright 2013, Dell 
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
require 'test_helper'
require 'json'

class AttribTestModelTest < ActiveSupport::TestCase

  # tests the relationship between nodes and attributes
  def setup
    # setup node w/ attribute
    @value = "unit test"
    @crowbar = Barclamp.find_or_create_by_name :name=>"test"
    @node = Node.find_or_create_by_name :name=>"units.test.com"
    @attrib = AttribType.add :name=>"barclamp_subclass_test"
    @na = @node.set_attrib @attrib, @value, nil, BarclampTest::AttribTest
    assert_not_nil @na
    assert_instance_of BarclampTest::AttribTest, @na
    assert_equal "test:"+@value, @na.value
    # Ruby 1.8 and 1.9 raise different exceptions in this case, so handle it
    # accordingly. Simplify once we remove 1.8 support.
    @error_class = (RUBY_VERSION == '1.8.7') ? NameError : ArgumentError
  end

  test "make sure that we can subclass Attrib in barclamps" do
    a = AttribType.create :name=>"got_class"
    assert_not_nil a
    ai = BarclampTest::AttribTest.create :attrib_type_id=>a.id, :node_id => @node.id
    assert_not_nil ai
    assert_instance_of BarclampTest::AttribTest, ai
    assert_equal "got_class", ai.attrib_type.name
    assert_equal "got_class", ai.name
  end

  test "make sure that we can node attrib_set takes subclass" do
    na = @node.set_attrib "subclass_me", "override", nil, BarclampTest::AttribTest
    assert_instance_of BarclampTest::AttribTest, na
    assert_equal "test:override", na.value
    assert_equal "subclass_me", na.attrib_type.name
    assert_equal :test, na.state    
  end

end
