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

class BarclampTest::Attrib < Attrib

  def value(data)

    case self.map
    when 'random'
      data['test']['random'].to_i
    when 'marker'
      data['test']['marker']
    else
      raise 'unknown map'
    end

  end

  def discovery(data)

    case self.map
    when 'random'
      { 'test'=> {'random'=>data}}
    when 'marker'
      { 'test'=> {'marker'=>data}}
    else
      raise 'unknown map'
    end

  end
    
end
