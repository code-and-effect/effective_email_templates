module EffectiveEmailTemplates
  class Importer
    def self.import(quiet: false, paths: nil)
      new().execute(overwrite: false, paths: paths, quiet: quiet)
    end

    def self.overwrite(quiet: false, paths: nil)
      new().execute(overwrite: true, paths: paths, quiet: quiet)
    end

    def execute(overwrite:, paths: nil, quiet: false)
      return false unless ActiveRecord::Base.connection.table_exists?(EffectiveEmailTemplates.email_templates_table_name)

      paths ||= if defined?(Tenant)
        raise('expected a tenant') unless Tenant.current.present?
        ActionController::Base.view_paths.reject { |view| view.path.include?('/apps/') }.map(&:path) + Tenant.view_paths.map(&:to_s)
      else
        ActionController::Base.view_paths.map(&:path)
      end

      paths.each do |path|
        Dir[Rails.root.join(path, '**', '*_mailer/', '*.liquid')].each do |filepath|
          name = File.basename(filepath, '.liquid')
          email_template = Effective::EmailTemplate.find_or_initialize_by(template_name: name)

          if email_template.persisted? && !overwrite
            puts("SKIPPED #{filename(filepath)}") unless quiet
            next
          end

          save(email_template, filepath, quiet: quiet)
        end
      end
    end

    private

    def save(email_template, filepath, quiet:)
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
        puts("SUCCESS #{filename(filepath)}") unless quiet
      else
        puts "ERROR #{filename(filepath)}: #{email_template.errors.full_messages.to_sentence}"
      end
    end

    def filename(filepath)
      filepath.sub(Rails.root.to_s + '/app/', '')
    end

  end
end
