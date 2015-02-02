require 'spec_helper'
require 'effective_email_templates/template_importer'

describe EffectiveEmailTemplates::TemplateImporter do
  it 'imports templates from view files' do
    Effective::EmailTemplate.delete_all
    expect{ EffectiveEmailTemplates::TemplateImporter.invoke }.to change { Effective::EmailTemplate.count }
  end

  it 'does not import templates if a template already exists in the database' do
    Effective::EmailTemplate.delete_all
    expect{ EffectiveEmailTemplates::TemplateImporter.invoke }.to change { Effective::EmailTemplate.count }
    expect{ EffectiveEmailTemplates::TemplateImporter.invoke }.to_not change { Effective::EmailTemplate.count }
  end
end
