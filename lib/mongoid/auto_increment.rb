module Mongoid
  module AutoIncrement
    extend ActiveSupport::Concern

    included do
      field :_i, :type => Integer

      cattr_accessor :auto_increment_scope

      set_callback :create, :before, :_mongoid_auto_increment_set__i
    end

    def _mongoid_auto_increment_set__i(atomic = false)
      i = Sequence.next_for_key(self._mongoid_auto_increment_scope)
      atomic ? self.set(:_i, i) : self._i = i
    end

    def _mongoid_auto_increment_scope
      if self.class.auto_increment_scope 
        if self.class.auto_increment_scope.respond_to?(:call)
          self.class.auto_increment_scope.call(self)
        elsif self.class.auto_increment_scope.is_a?(Symbol)
          context = self.send(self.class.auto_increment_scope)
          "#{self.class.auto_increment_scope}.#{(context.respond_to?(:id) ? context.id : context).to_s}.#{self.collection.name}"
        else
          self.class.auto_increment_scope.to_s
        end
      else
        self.class.collection.name
      end
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