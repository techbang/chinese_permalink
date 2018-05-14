require 'net/http'

module ChinesePermalink
  def self.included(base)
    base.class_eval do
      class_attribute :permalink_attrs, :permalink_field, :before_methods, :after_methods
    end
    base.extend ClassMethods
    base.include InstanceMethods
  end

  private

  def create_permalink
    if self.permalink.nil? || self.permalink.blank?
      chinese_permalink = self.class.permalink_attrs.collect do |attr_name|
        chinese_value = self.send(attr_name)
      end * '-'
      self.class.before_methods.each do |method|
        chinese_permalink = self.send(method, chinese_permalink)
      end

      english_permalink = Translate.t(chinese_permalink)
      self.class.after_methods.each do |method|
        english_permalink = self.send(method, english_permalink)
      end

      english_permalink = format_process(english_permalink)
      self.update_column(:"#{self.class.permalink_field}", english_permalink)
    end
  end

  def try_create_permalink
    create_permalink
  rescue => e
    # do nothing
  end

  def format_process(text)
    remove_duplicate_dash(remove_heading_dash(remove_tailing_dash(remove_non_ascii(remove_space(remove_punctuation(text)))))).downcase
  end

  def remove_heading_dash(text)
    text.gsub(/^-+/, '')
  end

  def remove_tailing_dash(text)
    text.gsub(/-+$/, '')
  end

  def remove_non_ascii(text)
    text.gsub('_', '-').gsub(/[^-a-zA-Z0-9]/, '')
  end

  def remove_space(text)
    text.gsub(/\s+/, '-')
  end

  def remove_punctuation(text)
    text.gsub(/&#39;|&amp;|&quot;|&lt;|&gt;/, '').gsub(/\//, '-')
  end

  def remove_duplicate_dash(text)
    text.gsub(/-{2,}/, '-')
  end

  module ClassMethods
    def chinese_permalink(attr_names, options = {})
      options = {:permalink_field => 'permalink'}.merge(options)
      self.permalink_attrs = Array(attr_names)
      self.permalink_field = options[:permalink_field]
      self.before_methods = Array(options[:before_methods])
      self.after_methods = Array(options[:after_methods])

      after_save :try_create_permalink
    end
  end

  module InstanceMethods
    def sanitize_format(text)
      format_process(text)
    end
  end

  class Translate
    class << self
      def t(text)
        uri = URI(translator_endpoint)
        content = %Q( [{ "Text" : "#{text}" }] )
        request = set_request(uri, content)
        response = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') { |http| http.request(request) }
        result = response.body.force_encoding("utf-8")
        JSON.parse(result)[0]['translations'][0]['text'].to_s
      end

      def set_request(uri, content)
        request = Net::HTTP::Post.new(uri)
        request['Content-type'] = 'application/json'
        request['Content-length'] = content.length
        request['Ocp-Apim-Subscription-Key'] = access_token
        request['X-ClientTraceId'] = SecureRandom.uuid
        request.body = content
        request
      end

      def translator_endpoint
        'https://api.cognitive.microsofttranslator.com/translate?api-version=3.0&to=en'
      end

      def access_token
        YAML.load(File.open(File.join(Rails.root, "config/chinese_permalink.yml")))['microsoft']['key']
      end
    end
  end
end

ActiveRecord::Base.send :include, ChinesePermalink
