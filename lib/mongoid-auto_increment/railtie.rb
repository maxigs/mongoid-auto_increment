# encoding: utf-8

module Rails #:nodoc:
  module Mongoid #:nodoc:
    class Railtie < Rails::Railtie #:nodoc:

      rake_tasks do
        load "mongoid-auto_increment/railties/auto_increment.rake"
      end

    end
  end
end
