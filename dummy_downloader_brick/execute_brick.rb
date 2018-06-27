# encoding: utf-8

require 'gooddata_connectors_base'
require 'gooddata_connectors_downloader_dummy/version'
require 'gooddata_connectors_downloader_dummy/dummy_downloader'

module GoodData
  module Connectors
    module DummyDownloader
      class DummyDownloaderMiddleware < GoodData::Bricks::Middleware
        def call(params)
          $log = params['GDC_LOGGER']
          $log.info 'Initializing DummyDownloaderMiddleware'
          dummy_downloader = DownloaderDummy.new(params['metadata_wrapper'], params)
          @app.call(params.merge('dummy_downloader_wrapper' => dummy_downloader))
        end
      end
    end
  end
end