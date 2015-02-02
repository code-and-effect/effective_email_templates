namespace :effective_email_templates do
  task :import_default_views => :environment do
    TemplateImporter.invoke
  end
end
