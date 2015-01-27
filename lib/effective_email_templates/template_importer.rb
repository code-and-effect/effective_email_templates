class TemplateImporter
  def self.invoke
    new.invoke
  end

  def invoke
    liquid_templates_finder = Rails.root.join('app', 'views', '*_liquid')
    Dir[liquid_templates_finder].each do |liquid_templates_directory|
      Dir[File.join(liquid_templates_directory, '*.liquid')].each do |liquid_template_filepath|
        template = Effective::EmailTemplate.new()
        template.slug = File.basename(liquid_template_filepath, '.liquid')
        file = File.new(liquid_template_filepath, "r")
        template = add_template_meta(file, template)
        template.body = extract_template_body(file)
        template.save
      end
    end
  end

  private

  def add_template_meta(file, template)
    template.attributes = File.open(file) do |f|
      YAML::load(f)
    end
    template
  end

  def extract_template_body file
    contents = file.read
    return unless match = contents.match(/(---+(.|\n)+---+)/)
    contents.gsub(match[1], '').strip
  end
end
