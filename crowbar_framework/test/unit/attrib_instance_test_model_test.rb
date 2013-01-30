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

class AttribInstanceTestModelTest < ActiveSupport::TestCase

  # tests the relationship between nodes and attributes
  def setup
    # setup node w/ attribute
    @value = "unit test"
    @crowbar = Barclamp.find_or_create_by_name :name=>"test"
    @node = Node.find_or_create_by_name :name=>"units.test.com"
    @attrib = Attrib.find_or_create_by_name :name=>"barclamp_subclass_test"
    @na = @node.attrib_set @attrib, @value, nil, Test::AttribInstanceTest
    assert_not_nil @na
    assert_equal "test:"+@value, @na.value
    # Ruby 1.8 and 1.9 throws different exceptions in this case, so handle it
    # accordingly. Simplify once we remove 1.8 support.
    @error_class = (RUBY_VERSION == '1.8.7') ? NameError : ArgumentError
  end

  test "make sure that we can subclass AttribInstance in barclamps" do
    a = Attrib.create :name=>"got_class"
    assert_not_nil a
    ai = Test::AttribInstanceTest.create :attrib_id=>a.id, :node_id => @node.id
    assert_not_nil ai
    assert_instance_of Test::AttribInstanceTest, ai
    assert_equal "got_class", ai.attrib.name
  end

  test "make sure that we can node attrib_set takes subclass" do
    na = @node.attrib_set "subclass_me", "override", nil, Test::AttribInstanceTest
    assert_instance_of Test::AttribInstanceTest, na
    assert_equal "test:override", na.value
    assert_equal "subclass_me", na.attrib.name
    assert_equal :test, na.state    
  end

end