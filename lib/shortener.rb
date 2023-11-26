require './shortener/version'

module Shortener
  class Error < StandardError; end

  def self.deep_equal?(hash1, hash2)
    hash1 == hash2
  end
end

require 'securerandom'
require 'json'

class URLShortener
  attr_reader :url_map, :base_url

  def initialize(file_path)
    @file_path = file_path
    load_urls_from_file
  end

  def separate_url_parts(url)
    url_parts = {}
    parts = url.match(%r{\A(?<protocol>https?://)?(?<domain>[^/]+)(?<path>.*)\z})
    url_parts[:protocol] = parts[:protocol] || 'http://'
    url_parts[:domain] = parts[:domain]
    url_parts[:path] = parts[:path]
    url_parts
  end

  def shorten(original_url)
    short_code = generate_short_code
    @url_map[short_code] = original_url
    save_urls_to_file
    "#{@base_url}/#{short_code}"
  end

  def redirect(short_code)
    @url_map[short_code]
  end

  private

  def generate_short_code
    SecureRandom.hex(3)
  end

  def load_urls_from_file
    if File.exist?(@file_path)
      file_content = File.read(@file_path)
      data = JSON.parse(file_content)
      @url_map = data['urls']
      @base_url = data['base_url']
    else
      @url_map = {}
      print 'Ingresa el dominio base (por ejemplo, https://esave.es/): '
      @base_url = gets.chomp
      save_urls_to_file
    end
  end

  def save_urls_to_file
    data = { 'base_url' => @base_url, 'urls' => @url_map }
    File.open(@file_path, 'w') do |file|
      file.write(JSON.pretty_generate(data))
    end
  end

  def save_just_base_urls_to_file
    @url_map = {}
    print 'Ingresa el dominio base (por ejemplo, https://esave.es/): '
    data = { 'base_url' => @base_url }
    File.open(@file_path, 'w') do |file|
      file.write(JSON.pretty_generate(data))
    end
  end
end

# Menu
while true
  print '1 - agregar dominio | 2 - Consultar? | q o Q para salir: '
  query = gets.chomp
  file_path = 'urls.json'
  shortener = URLShortener.new(file_path)
  case query
  when '1'
    puts 'Ingresa la URL larga a acortar: '
    long_url = gets.chomp
    shortened_url = shortener.shorten(long_url)
    puts "URL acortada: #{shortened_url}"
  when '2'
    print 'Ingresa el código corto o Url Completa para redirigir a la URL original: '
    input_short_code = gets.chomp
    if input_short_code.length == 6
      original_url = shortener.redirect(input_short_code)
    else
      input_short_code = shortener.separate_url_parts(input_short_code)
      extracted_input_short_code = input_short_code[:path]
      if extracted_input_short_domain_code = input_short_code[:domain] == 'esave.es'
        original_url = shortener.redirect(extracted_input_short_code[1, 6])
      else
        puts 'invalid domain'
      end
    end
    if original_url
      puts "Redirigiendo a: #{original_url}"
    else
      puts 'Código corto inválido o URL no encontrada.'
    end
  when 'q', 'Q'
    break
  else
    puts 'please retry'
  end
end
