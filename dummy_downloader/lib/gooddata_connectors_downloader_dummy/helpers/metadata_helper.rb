# Copyright (c) 2018, GoodData Corporation. All rights reserved.
# This source code is licensed under the BSD-style license found in the
# LICENSE file in the root directory of this source tree.

module GoodData::Connectors::DummyDownloader
  module Helpers
    module MetadataHelper
      # Set custom metadata
      # @param [Entity] metadata_entity Entity to set
      def load_entity_custom_metadata(metadata_entity)
        if metadata_entity.custom['download_by'] != self.class::TYPE
          metadata_entity.custom['download_by'] = self.class::TYPE
          metadata_entity.make_dirty
        end

        if metadata_entity.custom['escape_as'] != '"'
          metadata_entity.custom['escape_as'] = '"'
          metadata_entity.make_dirty
        end

        if metadata_entity.custom['file_format'] != 'GZIP'
          metadata_entity.custom['file_format'] = 'GZIP'
          metadata_entity.make_dirty
        end
      end

      # @override BaseDownloader#load_entity_fields
      def load_entity_fields(entity, requested_fields)
        temporary_fields = requested_fields.map { |f| new_field(f['name'], convert_field_type(entity, f['type'], f['name'])) }
        diff = entity.diff_fields(temporary_fields)
        load_fields_from_source(diff, entity)
        disable_fields(diff, entity)
        change_fields(diff, entity)
      end

      # Save all given results to BDS
      # @param [Array] entity_results 
      def save_to_s3(entity_results)
        entity_results.each do |entity, local_path|
          if local_path && !local_path.empty?
            save_data(entity, local_path)
          else
            $log.warn "No data was returned for entity #{entity.name}." unless local_path
          end
        end
      end

      # Save data to BDS and store the
      # @param [Entity] metadata_entity Metadata entity
      # @param [String] local_path Relative path pointing to the result CSV file
      def save_data(metadata_entity, local_path)
        $log.info 'Saving data to the BDS.'
        local_path = pack_data(local_path)
        metadata_entity.store_runtime_param('source_filename', local_path)
        metadata_entity.store_runtime_param('date_from', Time.now)
        metadata_entity.store_runtime_param('date_to', Time.now)
        @metadata.save_data(metadata_entity)
        GoodData::Connectors::Metadata::Runtime.reset_now
      end
    end
  end
end