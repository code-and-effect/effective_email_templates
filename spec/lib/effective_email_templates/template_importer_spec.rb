require 'spec_helper'
require 'effective_email_templates/template_importer'

describe EffectiveEmailTemplates::TemplateImporter do
  before :each do
      Effective::EmailTemplate.delete_all
  end

  describe 'well formatted template files' do
    it 'imports templates from view files' do
      expect{ EffectiveEmailTemplates::TemplateImporter.invoke }.to change { Effective::EmailTemplate.count }
    end

    it 'does not import templates if a template already exists in the database' do
      expect{ EffectiveEmailTemplates::TemplateImporter.invoke }.to change { Effective::EmailTemplate.count }
      expect{ EffectiveEmailTemplates::TemplateImporter.invoke }.to_not change { Effective::EmailTemplate.count }
    end

    it 'does not print errors' do
      importer = EffectiveEmailTemplates::TemplateImporter.new
      expect(importer).to_not receive(:print_errors)
      EffectiveEmailTemplates::TemplateImporter.invoke(importer)
    end
  end

  describe 'poorly formatted template files' do
    let(:filepath) { Rails.root.join('app', 'views', 'user_liquid', 'some_template.liquid') }
    before do
      File.open(filepath, 'w') do |f|
        f.write("--\n---\nbody")
      end
    end

    after do
      File.delete(filepath)
    end

    it 'prints errors if there is a problem with a template' do
      importer = EffectiveEmailTemplates::TemplateImporter.new
      expect(importer).to receive(:print_errors)
      EffectiveEmailTemplates::TemplateImporter.invoke(importer)
    end
  end
end
