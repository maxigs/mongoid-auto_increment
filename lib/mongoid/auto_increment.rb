module Mongoid
  module AutoIncrement

  extend ActiveSupport::Concern

    included do
      field :incr, :type => Integer
      set_callback :create, :before, :set_incr
    end

    def set_incr
      self.incr = AutoIncrementSequence.next_for_key(self.class.to_s)
    end

    class AutoIncrementSequence
      include ::Mongoid::Document

      class << self

        def next_for_key(key)
          collection.find_and_modify({
            :query  => {_id: key},
            :update => {:$inc => {:seq => 1}},
            :new    => true,
            :upsert => true,
            :fields => [:seq]
          })[:seq]
        end

      end
    end

  end
end
