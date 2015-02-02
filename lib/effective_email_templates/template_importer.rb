module EffectiveEmailTemplates
  class TemplateImporter
    def self.invoke
      new.invoke
    end

    def invoke
      Dir[Rails.root.join('app', 'views', '**', '*.liquid')].each do |liquid_template_filepath|
        slug = File.basename(liquid_template_filepath, '.liquid')
        next if Effective::EmailTemplate.where(slug: slug).present?

        template = Effective::EmailTemplate.new(slug: slug)

        file = File.new(liquid_template_filepath, "r")
        template = add_template_meta(file, template)
        template.body = extract_template_body(file)
        template.save
        print_errors(template, liquid_template_filepath)
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

    def print_errors(template, liquid_template_filepath)
      if template.errors
        puts "ERROR -- There was one or more validation errors while uploading:"
        puts "  Email Template: #{liquid_template_filepath}"
        template.errors.each do |attribute, error|
          puts "  -> #{attribute} #{error}"
        end
      end
    end
  end
end
