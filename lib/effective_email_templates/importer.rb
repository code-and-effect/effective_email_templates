module EffectiveEmailTemplates
  class Importer
    def self.import
      new().execute(overwrite: false)
    end

    def self.overwrite
      new().execute(overwrite: true)
    end

    def execute(overwrite:)
      Dir[Rails.root.join('app', 'views', '**', '*.liquid')].each do |filepath|
        name = File.basename(filepath, '.liquid')
        email_template = Effective::EmailTemplate.find_or_initialize_by(template_name: name)

        if email_template.persisted? && !overwrite
          puts "SKIPPED #{filename(filepath)}"; next
        end

        save(email_template, filepath)
      end
    end

    private

    def save(email_template, filepath)
      file = File.new(filepath, 'r')

      attributes = begin
        content = YAML.load(file)
        content.kind_of?(Hash) ? content : {}
      end

      body = File.open(file) do |f|
        content = f.read
        match = content.match(/(---+(.|\n)+---+)/)
        content.gsub(match[1], '').strip if match
      end

      email_template.assign_attributes(attributes)
      email_template.assign_attributes(body: body)

      if email_template.save
        puts "SUCCESS #{filename(filepath)}"
      else
        puts "ERROR #{filename(filepath)}: #{email_template.errors.full_messages.to_sentence}"
      end
    end

    def filename(filepath)
      filepath.sub(Rails.root.to_s + '/app/', '')
    end

  end
end
