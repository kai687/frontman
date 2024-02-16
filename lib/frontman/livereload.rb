# typed: strict
# frozen_string_literal: false

require 'em-websocket'
require 'English'
require 'json'
require 'sorbet-runtime'

module Frontman
  module LiveReload
    extend T::Sig

    # Set defaults. Both websocket client and server must use the same
    @wss_host = T.let('localhost', String)
    @wss_port = T.let(35_355, Integer)

    sig { returns(String) }
    def self.wss_host
      @wss_host
    end

    sig { returns(Integer) }
    def self.wss_port
      @wss_port
    end

    class Server
      extend T::Sig

      sig { returns(Thread) }
      attr_reader :thread

      sig { returns(T::Array[T.untyped]) }
      attr_reader :websockets

      sig { params(host: String, port: Integer).void }
      def initialize(host = Frontman::LiveReload.wss_host, port = Frontman::LiveReload.wss_port)
        @host = host
        @port = port
        @websockets = T.let([], T::Array[T.untyped])
        @thread = T.let(start_server, T.untyped)
      end

      sig { returns(Thread) }
      def start_server
        Thread.new do
          EventMachine.run do
            EventMachine.start_server(@host, @port, EventMachine::WebSocket::Connection, {}) do |ws|
              print "== LiveReload server listening on port #{@port}\n"
              ws.onopen do
                ws.send '!!ver:2.08'
                @websockets << ws
              rescue StandardError
                warn $ERROR_INFO
              end

              ws.onclose do
                @websockets.delete ws
              end
            end
          end
        end
      end

      sig { void }
      def reload_client
        data = JSON.dump(['refresh', { path: '' }])
        @websockets.each { |ws| ws.send(data) }
      end

      sig { void }
      def stop
        thread.kill
      end
    end
  end
end
