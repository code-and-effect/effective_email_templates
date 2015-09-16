namespace :effective_email_templates do
  desc 'Import email templates from the filesystem to the database. This rake task does not overwrite existing database templates.'
  task import_templates: :environment do
    EffectiveEmailTemplates::TemplateImporter.invoke
  end

  desc 'Overwrite existing default database email templates from the filesystem.'
  task overwrite_templates: :environment do
    puts 'By running this task, all email templates that exist in the database will be overwritten by the templates in the filesystem. Do you still want to run this task? (Y/n): '
    answer = $stdin.gets.chomp

    if answer.downcase == 'y'
      EffectiveEmailTemplates::TemplateImporter.invoke(overwrite: true)
      puts 'Default email templates have been overwritten successfully!'
    else
      puts 'Cancelled!'
    end
  end
end
