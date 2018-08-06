# encoding: utf-8

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