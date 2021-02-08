require 'digest'
require 'rest-client'
require 'json'
require 'yaml'

module SendCloud
  class SMS
    def self.load!(file, environment)
      config = YAML.load_file(file)
      auth(config[environment.to_s]['user'], config[environment.to_s]['api_key'])
    end

    def self.auth(user, api_key)
      @user = user
      @api_key = api_key
    end

    def self.sign(template, phone, vars)
      param_str = "#{@api_key}&"
      {
        smsUser: @user,
        templateId: template,
        msgType: 0,
        phone: phone.is_a?(Array) ? phone.join(',') : phone,
        vars: vars.to_json
      }.sort_by(&:to_s).map { |item| param_str << "#{item[0]}=#{item[1]}&" }
      param_str << @api_key
      Digest::MD5.new.update(param_str)
    end

    def self.sign_voice(phone, code)
      param_str = "#{@api_key}&"
      {
        smsUser: @user,
        phone: phone,
        code: code
      }.sort_by(&:to_s).map { |item| param_str << "#{item[0]}=#{item[1]}&" }
      param_str << @api_key
      Digest::MD5.new.update(param_str)
    end

    def self.send_sms(template, phone, vars)
      request(
        'smsapi/send?',
        smsUser: @user,
        templateId: template,
        msgType: 0,
        phone: phone.is_a?(Array) ? phone.join(',') : phone,
        vars: vars.to_json,
        signature: sign(template, phone, vars)
      )
    end

    def self.send_voice(phone, code)
      request(
        'smsapi/sendVoice?',
        smsUser: @user,
        phone: phone,
        code: code,
        signature: sign_voice(phone, code)
      )
    end

    def self.request(path, **params)
      json_resp = RestClient.post "http://sendcloud.sohu.com/#{path}", **params
      resp = JSON.parse(json_resp.to_s)
      status_code = resp['statusCode']
      raise SendError.new(resp['message'], status_code) unless status_code == 200

      resp['info']
    end

    class SendError < StandardError
      attr_reader :message, :status_code

      def initialize(message, status_code)
        super("Sendcloud API Error (#{status_code}): #{message}")
        @message = message
        @status_code = status_code
      end
    end
  end
end
