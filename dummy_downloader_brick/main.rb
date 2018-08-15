# Copyright (c) 2018, GoodData Corporation. All rights reserved.
# This source code is licensed under the BSD-style license found in the
# LICENSE file in the root directory of this source tree.

require 'fileutils'
FileUtils.mkdir_p('output')
FileUtils.mkdir_p('tmp')

puts 'You are using DEVELOPMENT version of the downloader!'

# Required gems
require 'bundler/setup'
require 'gooddata'
require 'gooddata_connectors_metadata'
require 'gooddata_connectors_downloader_dummy'

# Require executive brick
$:.unshift(File.dirname(__FILE__))
require 'execute_brick'

include GoodData::Bricks

GoodData.logging_on

# Prepare stack
stack = [
  LoggerMiddleware,
  BenchMiddleware,
  AWSMiddleware,
  WarehouseMiddleware,
  GoodData::Connectors::Metadata::MetadataMiddleware,
  GoodData::Connectors::DummyDownloader::DummyDownloaderMiddleWare,
  ExecuteBrick
]

# Create pipeline
p = GoodData::Bricks::Pipeline.prepare(stack)

# Default script params
$SCRIPT_PARAMS = {} if $SCRIPT_PARAMS.nil?

# Setup params
$SCRIPT_PARAMS['GDC_LOGGER'] = Logger.new(STDOUT)

# Execute pipeline
p.call($SCRIPT_PARAMS)
