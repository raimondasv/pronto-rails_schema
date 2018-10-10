require 'pronto'

module Pronto
  class RailsSchema < Runner
    def run
      if migration_patches.any?
        if schema_file_present?
          return generate_messages_for('schema.rb') unless changes_detected?(schema_patch)
        end

        if structure_file_present?
          return generate_messages_for('structure.sql') unless changes_detected?(structure_patch)
        end
      else
        if schema_file_present?
          return generate_message_for('schema.rb', schema_patch) if changes_detected?(schema_patch)
        end

        if structure_file_present?
          return generate_message_for('structure.sql', structure_patch) if changes_detected?(structure_patch)
        end
      end
      []
    end

    private

    def schema_file_present?
      File.exist?('db/schema.rb')
    end

    def structure_file_present?
      File.exists?('db/structure.sql')
    end

    def migration_patches
      return [] unless @patches
      @migration_patches ||= @patches
        .select { |patch| detect_added_migration_file(patch) }
    end

    def generate_messages_for(target)
      migration_patches.map do |patch|
        first_line = patch.added_lines.first
        Message.new(patch.delta.new_file[:path], first_line, :warning,
                  "Migration file detected, but no changes in #{target}",
          nil, self.class)
      end
    end

    def generate_message_for(target, patch)
      first_line = patch.added_lines.first
      Message.new(patch.delta.new_file[:path], first_line, :warning,
        "There are no added migration file, but something changes in #{target}",
nil, self.class)
    end

    def detect_added_migration_file(patch)
      return unless patch.delta.added?
      /(.*)db[\\|\/]migrate[\\|\/](\d{14}_([_A-Za-z]+)\.rb)$/i =~ patch.delta.new_file[:path]
    end

    def detect_schema_file(path)
      /db[\\|\/]schema.rb/i =~ path.to_s
    end

    def changes_detected?(patch)
      patch && (patch.additions > 0 || patch.deletions > 0)
    end

    def detect_structure_file(path)
      /db[\\|\/]structure.sql/i =~ path.to_s
    end

    def schema_patch
      @patches.find { |patch| detect_schema_file(patch.new_file_full_path) }
    end

    def structure_patch
      @patches.find { |patch| detect_structure_file(patch.new_file_full_path) }
    end
  end
end
