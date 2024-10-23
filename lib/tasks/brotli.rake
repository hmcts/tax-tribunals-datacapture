namespace :assets do
  task :brotli => :environment do

    require 'brotli'

    assets_dir = Rails.root.join('public', 'assets')

    Dir.glob("#{assets_dir}/**/*.{js,css,html,json,svg}") do |file|
      next if File.directory?(file) || file.end_with?('.br')

      brotli_compressed = Brotli.deflate(File.binread(file))

      File.open("#{file}.br", 'wb') do |f|
        f.write(brotli_compressed)
      end
    end
  end
end