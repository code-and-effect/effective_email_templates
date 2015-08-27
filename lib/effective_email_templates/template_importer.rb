module EffectiveEmailTemplates
  class TemplateImporter
    def self.invoke(importer = new, overwrite: false)
      importer.invoke(overwrite)
    end

    def invoke(overwrite = false)
      Dir[Rails.root.join('app', 'views', '**', '*.liquid')].each do |liquid_template_filepath|
        slug = File.basename(liquid_template_filepath, '.liquid')
        template = Effective::EmailTemplate.find_or_initialize_by(slug: slug)

        update_template(template, liquid_template_filepath) if (template.persisted? && overwrite) || template.new_record?
      end
    end

  private

    def add_template_meta(file, template)
      template.attributes = File.open(file) do |f|
        attr = YAML.load(f)
        attr.is_a?(Hash) ? attr : {}
      end
      template
    end

    def extract_template_body(file)
      contents = file.read
      match = contents.match(/(---+(.|\n)+---+)/)

      contents.gsub(match[1], '').strip if match
    end

    def print_errors(template, liquid_template_filepath)
      puts 'ERROR -- There was one or more validation errors while uploading:'
      puts "  Email Template: #{liquid_template_filepath}"
      template.errors.each do |attribute, error|
        puts "  -> #{attribute} #{error}"
      end
    end

    def update_template(template, liquid_template_filepath)
      file = File.new(liquid_template_filepath, 'r')

      template = add_template_meta(file, template)
      template.body = extract_template_body(file)
      template.save

      print_errors(template, liquid_template_filepath) unless template.valid?
    end
  end
end
