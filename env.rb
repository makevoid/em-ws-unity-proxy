require 'yaml'

require 'bundler'
Bundler.require :default

PATH = File.expand_path Dir.pwd

PING_I  = { op: "ping_INT" }
PING    = { op: "ping" }
BLOCKS  = { op: "blocks_sub" }
UTX     = { op: "unconfirmed_sub" }

class App
  def self.path
    PATH
  end
end
