# Copyright (c) 2018, GoodData Corporation. All rights reserved.
# This source code is licensed under the BSD-style license found in the
# LICENSE file in the root directory of this source tree.

require 'gooddata_connectors_base'
require 'gooddata_connectors_downloader_dummy/version'
require 'gooddata_connectors_downloader_dummy/dummy_downloader'

module GoodData
  module Connectors
    module DummyDownloader
      class DummyDownloaderMiddleWare < GoodData::Bricks::Middleware
        def call(params)
          $log = params['GDC_LOGGER']
          $log.info 'Initializing DummyDownloaderMiddleWare'
          dummy_downloader = DownloaderDummy.new(params['metadata_wrapper'], params)
          @app.call(params.merge('dummy_downloader_wrapper' => dummy_downloader))
        end
      end
    end
  end
end
