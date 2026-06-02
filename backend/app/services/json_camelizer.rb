module JsonCamelizer
  module_function

  def camelize(value)
    case value
    when Hash
      value.each_with_object({}) do |(k, v), result|
        key = k.to_s.camelize(:lower)
        result[key] = camelize(v)
      end
    when Array
      value.map { |item| camelize(item) }
    when Time, ActiveSupport::TimeWithZone
      value.iso8601(3)
    when Date
      value.iso8601
    else
      value
    end
  end
end
