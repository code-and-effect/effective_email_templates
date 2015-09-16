require 'spec_helper'
require 'effective_email_templates/template_importer'

describe EffectiveEmailTemplates::TemplateImporter do
  before { Effective::EmailTemplate.delete_all }

  describe '.invoke' do
    context 'without overwriting' do
      context 'when well formatted template files' do
        it 'should import templates from view files' do
          expect { EffectiveEmailTemplates::TemplateImporter.invoke }.to change { Effective::EmailTemplate.count }
        end

        it 'should not import templates if a template already exists in the database' do
          expect { EffectiveEmailTemplates::TemplateImporter.invoke }.to change { Effective::EmailTemplate.count }
          expect { EffectiveEmailTemplates::TemplateImporter.invoke }.to_not change { Effective::EmailTemplate.count }
        end

        it 'should not print errors' do
          importer = EffectiveEmailTemplates::TemplateImporter.new
          expect(importer).to_not receive(:print_errors)
          EffectiveEmailTemplates::TemplateImporter.invoke(importer)
        end
      end

      context 'when poorly formatted template files' do
        let(:filepath) { Rails.root.join('app', 'views', 'user_liquid', 'some_template.liquid') }

        before { File.open(filepath, 'w') { |f| f.write("--\n---\nbody") } }
        after { File.delete(filepath) }

        it 'should print errors if there is a problem with a template' do
          importer = EffectiveEmailTemplates::TemplateImporter.new
          expect(importer).to receive(:print_errors)
          EffectiveEmailTemplates::TemplateImporter.invoke(importer)
        end
      end
    end

    context 'with overwriting' do
      let!(:existing_template) { FactoryGirl.create(:email_template, body: 'test', slug: 'after_create_user') }

      context 'when well formatted template files' do
        it 'should update templates from view files' do
          expect { EffectiveEmailTemplates::TemplateImporter.invoke(overwrite: true) }.to change { existing_template.reload.body }.from('test').to('Hello {{ user_name }}')
        end

        it 'should not create duplicate templates if a template already exists in the database' do
          expect { EffectiveEmailTemplates::TemplateImporter.invoke(overwrite: true) }.not_to change { Effective::EmailTemplate.count }
        end

        it 'should not print errors' do
          importer = EffectiveEmailTemplates::TemplateImporter.new
          expect(importer).to_not receive(:print_errors)
          EffectiveEmailTemplates::TemplateImporter.invoke(importer, overwrite: true)
        end
      end

      context 'when poorly formatted template files' do
        let(:filepath) { Rails.root.join('app', 'views', 'user_liquid', 'some_template.liquid') }

        before { File.open(filepath, 'w') { |f| f.write("--\n---\nbody") } }
        after { File.delete(filepath) }

        it 'should print errors if there is a problem with a template' do
          importer = EffectiveEmailTemplates::TemplateImporter.new
          expect(importer).to receive(:print_errors)
          EffectiveEmailTemplates::TemplateImporter.invoke(importer, overwrite: true)
        end
      end
    end
  end
end
