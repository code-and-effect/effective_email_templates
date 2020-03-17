# rake effective_email_templates:import
# rake effective_email_templates:overwrite

namespace :effective_email_templates do
  desc 'Import email templates from the filesystem to the database. Skips existing.'
  task import: :environment do
    require 'effective_email_templates/importer'
    EffectiveEmailTemplates::Importer.import()
  end

  desc 'Overwrite email templates from the filesystem to the database. Overwrites existing.'
  task overwrite: :environment do
    puts 'WARNING: this task will overwrite existing email templates. Proceed? (y/n)'
    (puts 'Aborted'; exit) unless STDIN.gets.chomp.downcase == 'y'

    require 'effective_email_templates/importer'
    EffectiveEmailTemplates::Importer.overwrite()
  end
end
