module Mongoid
  module AutoIncrement

  extend ActiveSupport::Concern

    included do
      field :_i, :type => Integer
      set_callback :create, :before, :_mongoid_auto_increment_set__i
    end

    def _mongoid_auto_increment_set__i
      self._i = Sequence.next_for_key(self.class.collection.name)
    end

    class Sequence
      include ::Mongoid::Document

      class << self

        def next_for_key(key)
          collection.find_and_modify({
            :query  => {_id: key},
            :update => {:$inc => {:seq => 1}},
            :new    => true,
            :upsert => true
          })['seq']
        end

      end
    end

  end
end
