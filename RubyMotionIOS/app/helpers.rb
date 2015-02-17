#
# Copyright (c) 2015 Harry Cheung
#

module JSON

  def self.parse(json_string)
    error = Pointer.new(:object)
    json_object = NSJSONSerialization.JSONObjectWithData(json_string.to_data, options: 0, error: error)
    if json_object.nil?
      puts error[0].localizedDescription
    end
    json_object
  end

end

class Float

  def format(f)
    "%#{f}f" % self
  end

end