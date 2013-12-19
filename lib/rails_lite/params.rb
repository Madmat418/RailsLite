require 'uri'

class Params
  attr_reader :params
  def initialize(req, route_params)
    @params = parse_www_encoded_form(req.query_string) if req.query_string
    if @params
      @params + parse_www_encoded_form(req.body) if req.body
    else
      @params = parse_www_encoded_form(req.body) if req.body
    end
  end

  def [](key)

  end

  def to_s
  end

  private
  def parse_www_encoded_form(www_encoded_form)
    result_hash = Hash.new { |h, k| h[k] = {} }
    result = Hash[URI.decode_www_form(www_encoded_form)]
    result.each do |key, value|
      key_array = parse_key(key)

      nested = nest(key_array << value)
      result_hash.merge!(nested) {|key,oldval,newval| oldval.merge(newval)}

      # inner_hash = {key_array.pop => value}
      # until key_array.length == 1
      #   middle_hash = {}
      #   middle_hash[key_array.pop] = inner_hash
      #   inner_hash = middle_hash
      # end
      # result_hash[key_array.pop] = inner_hash
    end
    result_hash
  end

  def parse_key(key)
    key.split(/\]\[|\[|\]/)
  end

  def nest(arr)
    if arr.length == 1
      arr[0]
    else
      { arr[0] => nest(arr[1..-1]) }
    end
  end
end
