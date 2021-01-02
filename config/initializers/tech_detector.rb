# frozen_string_literal: true

class TechDetector
  CACHE = LruRedux::Cache.new(10000)

  def self.detect(ua, cache = true)
    if cache
      CACHE.getset(ua) { self.detect_without_cache(ua) }
    else
      self.detect_without_cache(ua)
    end
  end

  def self.detect_without_cache(ua)
    client = DeviceDetector.new(ua)
    device_type =
        case client.device_type
        when "smartphone"
          "Mobile"
        when "tv"
          "TV"
        else
          client.device_type.try(:titleize)
        end

    {
      browser: client.name,
      os: client.os_name,
      device_type: device_type
    }
  end
end