# frozen_string_literal: false

require 'em-websocket'
require 'English'
require 'json'

module Frontman
  module LiveReload
    # Set defaults. Both websocket client and server must use the same
    @wss_host = 'localhost'
    @wss_port = 35_355

    def self.wss_host
      @wss_host
    end

    def self.wss_port
      @wss_port
    end

    class Server
      def initialize(host = Frontman::LiveReload.wss_host, port = Frontman::LiveReload.wss_port)
        @host = host
        @port = port
        @websockets = []
        @thread = start_server
      end

      def start_server
        Thread.new do
          EventMachine.run do
            EventMachine.start_server(@host, @port, EventMachine::WebSocket::Connection, {}) do |ws|
              ws.onopen do
                ws.send '!!ver:2.08'
                @websockets << ws
                print "== LiveReload client connected\n"
              rescue StandardError
                warn $ERROR_INFO
              end

              ws.onclose do
                @websockets.delete ws
                print "== LiveReload client disconnected\n"
              end
            end
          end
        end
      end

      def reload_client
        data = JSON.dump(['refresh', { path: '' }])
        @websockets.each { |ws| ws.send(data) }
      end

      def stop
        thread.kill
      end
    end
  end
end
