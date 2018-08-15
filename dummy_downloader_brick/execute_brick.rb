# Copyright (c) 2018, GoodData Corporation. All rights reserved.
# This source code is licensed under the BSD-style license found in the
# LICENSE file in the root directory of this source tree.

module GoodData::Bricks
  class ExecuteBrick < GoodData::Bricks::Brick
    def call(params)
      metadata = params['metadata_wrapper']
      downloader = params['dummy_downloader_wrapper']
      raise Exception, 'The schedule parameters must contain ID of the downloader' unless params.include?('ID')
      metadata.set_source_context(params['ID'], {}, downloader, false)

      downloader.download_data
    end
  end
end