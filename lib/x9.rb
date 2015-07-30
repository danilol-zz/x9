require 'rubygems'
require 'active_support'
require 'active_support/core_ext'
require 'logger'
require 'string'

class X9
  def initialize(options = { :file => "log/x9.log"})
    @logger = Logger.new(options[:file])
    set_default_format
  end

  def debug(params)
    @logger.debug prepare_log_line(params)
  end

  def info(params)
    @logger.info prepare_log_line(params)
  end

  def warn(params)
    @logger.warn prepare_log_line(params)
  end

  def error(params)
    @logger.error prepare_log_line(params)
  end

  def fatal(params)
    @logger.fatal prepare_log_line(params)
  end

  private
  def prepare_log_line(params)
    params = params ? params.stringify_keys! : {}
    "error=#{params["error"]}||method=#{params["method"]}||params=#{prepare_params(params["params"])}"
  end

  def prepare_params(params)
    params = params ? params.stringify_keys! : {}
    params.sort.map{|field, value|
      field = field.to_s
      if value.is_a?(Hash)
        value.sort.map{|sub_field, sub_value| "#{field.shortname}[#{sub_field.shortname}]=#{sub_value.to_s.replace_spaces}" }
      else
        "#{field.shortname}=#{value.to_s.replace_spaces}"
      end
    }.join('&&')
  end

  def set_default_format
    @logger.formatter = lambda do |severity, datetime, progname, msg|
      "#{DateTime.now.strftime('%Y-%m-%d %H:%M:%S.%L %z')}||#{severity}||#{generate_transaction_id}||#{msg}\n"
    end
  end

  def generate_transaction_id
    SecureRandom.hex(8)
  end
end
