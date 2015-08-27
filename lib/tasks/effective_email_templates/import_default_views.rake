namespace :effective_email_templates do
  desc 'Import email templates from the filesystem to the database. This rake task does not overwrite existing database templates.'
  task import_default_views: :environment do
    EffectiveEmailTemplates::TemplateImporter.invoke
  end

  desc 'Overwrite existing default database email templates from the filesystem.'
  task regenerate_default_views: :environment do
    EffectiveEmailTemplates::TemplateImporter.invoke(overwrite: true)
  end
end
