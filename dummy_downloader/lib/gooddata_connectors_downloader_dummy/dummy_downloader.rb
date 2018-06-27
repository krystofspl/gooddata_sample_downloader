# Copyright (c) 2018, GoodData Corporation. All rights reserved.
# This source code is licensed under the BSD-style license found in the
# LICENSE file in the root directory of this source tree.

require 'gooddata_connectors_base'

module GoodData
  module Connectors
    module DummyDownloader
      class DownloaderDummy < Base::BaseDownloader
        require_relative 'helpers/metadata_helper'
        include Helpers::MetadataHelper

        TYPE = 'dummy'.freeze

        attr_accessor :runtime_cache

        # Constructor for the downloader
        # @param [Metadata] metadata Metadata instance
        # @param [Hash] options Configuration for the downloader
        def initialize(metadata, options = {})
          $log.info 'Initializing DummyDownloader'
          raise ArgumentError, 'Metadata must be present.' unless metadata.is_a?(Metadata::Metadata)
          @runtime_cache = metadata.load_cache('previous_runtimes')

          super(metadata, options)
        end

        # Provide path to the JSON validation schema used for config validation
        def validation_schema
          File.join(File.dirname(__FILE__), 'schema/validation_schema.json')
        end

        # Wrapper method for the main downloader functionality
        def download_data
          # Custom downloader functionality implementation, this is just a simplified example template
          $log.info 'Starting downloading data from the Dummy API.'
          entities = @metadata.list_entities
          results = []
          entities.each do |entity|
            entity_custom = entity.custom
            load_metadata entity, entity_custom['fields']
            start_date, end_date = get_date_interval(entity)
            results << [entity, download_data_range(entity, start_date, end_date)]
          end
          save_to_s3 results
        end

        # Download a single date range for an entity
        # @param [Date] start_date Start date of the downloaded range
        # @param [Date] end_date End date of the downloaded range
        # @return [String] Path to the downloaded file
        def download_data_range(entity, start_date, end_date)
          # custom by API, returning a sample result file
          'output/entity_1_1529588678.csv'
        end

        # Compute date interval based on past run times
        # @param [Entity] entity Metadata entity for which to compute the interval
        # @return [Array<Date>] Start date and end date bounding the interval
        def get_date_interval(entity)
          entity_custom = entity.custom

          runtime_cache.hash[entity.id] = {} unless runtime_cache.hash[entity.id]
          previous_runtime = runtime_cache.hash[entity.id]['sys_runtime_date']
          last_end_date = runtime_cache.hash[entity.id]['end_date']
          last_end_date = Date.parse(last_end_date) if last_end_date
          initial_date = entity_custom['initial_load_start_date'] || @metadata.get_configuration_by_type_and_key(TYPE, 'options|initial_load_start_date')
          initial_date = Date.parse(initial_date) if initial_date
          full = (entity_custom['full'] || @metadata.get_configuration_by_type_and_key(TYPE, 'options|full')).to_s.casecmp('true').zero?

          $log.info 'No previous runtime information found, performing full download from initial date.' if !full && previous_runtime.nil?
          raise 'For full downloading, initial start date must be specified.' if !initial_date && (full || previous_runtime.nil?)

          start_date = (previous_runtime.nil? || full) ? initial_date : [last_end_date, Date.today].min
          end_date = Date.today

          return start_date, end_date
        end
      end
    end
  end
end